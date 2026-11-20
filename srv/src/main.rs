use axum::{
    body::Body,
    extract::{
        ws::{Message, WebSocket, WebSocketUpgrade},
        State,
    },
    http::{Method, StatusCode, Uri},
    response::{IntoResponse, Response},
    routing::get,
    Router,
};
use chrono::Local;
use futures_util::{SinkExt, StreamExt};
use regex::RegexBuilder;
use serde_json::{json, Value};
use std::{
    collections::{HashMap, VecDeque},
    net::SocketAddr,
    path::{Path as FsPath, PathBuf},
    sync::Arc,
    time::Duration,
};
use tokio::{
    net::TcpListener,
    sync::{mpsc, oneshot, Mutex, RwLock},
    time::sleep,
};
use tokio_tungstenite::{connect_async, tungstenite::Message as WsMessage};

#[derive(Clone, Debug)]
struct Cfg {
    port: u16,
    lr_enabled: bool,
    lr_port: u16,
    lr_debounce: u64,
    lr_ext: Vec<String>,
    lr_ex: Vec<String>,
    cdp_port: u16,
}

fn parse_args() -> Cfg {
    let mut c = Cfg {
        port: 8000,
        lr_enabled: true,
        lr_port: 12002,
        lr_debounce: 300,
        lr_ext: vec![".js".into(), ".css".into(), ".html".into(), ".json".into()],
        lr_ex: vec![
            ".git".into(),
            "node_modules".into(),
            "dist".into(),
            "build".into(),
        ],
        cdp_port: 9222,
    };
    let mut a = std::env::args().skip(1);
    while let Some(x) = a.next() {
        match x.as_str() {
            "--lr-port" => {
                if let Some(v) = a.next() {
                    c.lr_port = v.parse().unwrap_or(c.lr_port);
                }
            }
            "--lr-debounce" => {
                if let Some(v) = a.next() {
                    c.lr_debounce = v.parse().unwrap_or(c.lr_debounce);
                }
            }
            "--lr-extensions" => {
                if let Some(v) = a.next() {
                    c.lr_ext = v.split(',').map(|s| s.to_string()).collect();
                }
            }
            "--lr-exclude" => {
                if let Some(v) = a.next() {
                    c.lr_ex = v.split(',').map(|s| s.to_string()).collect();
                }
            }
            "--lr-disabled" => c.lr_enabled = false,
            "--cdp-port" => {
                if let Some(v) = a.next() {
                    c.cdp_port = v.parse().unwrap_or(c.cdp_port);
                }
            }
            s if s.starts_with("--") => {
                let _ = a.next();
            }
            s => {
                if let Ok(p) = s.parse() {
                    c.port = p;
                }
            }
        }
    }
    c
}

fn now_iso() -> String {
    chrono::Utc::now().to_rfc3339_opts(chrono::SecondsFormat::Millis, true)
}
fn now_ts() -> String {
    Local::now().format("%H:%M:%S").to_string()
}
fn epoch() -> f64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs_f64()
}

fn ansi(c: &str) -> &str {
    match c {
        "reset" => "\x1b[0m",
        "error" => "\x1b[1;31m",
        "warn" => "\x1b[1;33m",
        "info" => "\x1b[1;36m",
        "log" => "\x1b[0;37m",
        "timestamp" => "\x1b[0;90m",
        "source" => "\x1b[0;90m",
        _ => "\x1b[0;37m",
    }
}
fn format_log(level: &str, msg: &str, src: &str) -> String {
    let l = level.to_lowercase();
    format!(
        "{}[{}]{} {} {}{:5}{} {}[{}]{}: {}",
        ansi("timestamp"),
        now_ts(),
        ansi("reset"),
        "📝",
        ansi(&l),
        l,
        ansi("reset"),
        ansi("source"),
        src,
        ansi("reset"),
        msg
    )
}

struct ConsoleBuf {
    q: VecDeque<Value>,
    max: usize,
}
impl ConsoleBuf {
    fn new(max: usize) -> Self {
        Self {
            q: VecDeque::new(),
            max,
        }
    }
    fn push(&mut self, v: Value) {
        if self.q.len() == self.max {
            self.q.pop_front();
        }
        self.q.push_back(v);
    }
    fn drain(&mut self) -> Vec<Value> {
        self.q.drain(..).collect()
    }
    fn len(&self) -> usize {
        self.q.len()
    }
}

async fn try_bind(start: u16) -> Option<(TcpListener, u16)> {
    for off in 0..10 {
        let p = start.saturating_add(off);
        if let Ok(l) = TcpListener::bind(SocketAddr::from(([127, 0, 0, 1], p))).await {
            return Some((l, p));
        }
    }
    None
}

fn plugin_root() -> PathBuf {
    if let Ok(exe) = std::env::current_exe() {
        if let Some(p) = exe.parent() {
            if p.ends_with("release") || p.ends_with("debug") {
                if let Some(r) = p.ancestors().nth(3) {
                    if r.join("assets/inject").is_dir() {
                        return r.to_path_buf();
                    }
                }
            }
            if p.join("assets/inject").is_dir() {
                return p.to_path_buf();
            }
            if let Some(r) = p.parent() {
                if r.join("assets/inject").is_dir() {
                    return r.to_path_buf();
                }
            }
        }
    }
    std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."))
}
fn read_inject(root: &FsPath, name: &str) -> String {
    std::fs::read_to_string(root.join("assets/inject").join(name)).unwrap_or_default()
}

#[derive(Clone)]
struct App {
    cfg: Arc<RwLock<Cfg>>,
    dir: PathBuf,
    console: Arc<Mutex<ConsoleBuf>>,
    lr_port: Arc<RwLock<u16>>,
    lr_clients: Arc<Mutex<Vec<mpsc::UnboundedSender<String>>>>,
    cdp: Arc<Mutex<Option<Cdp>>>,
    inj_console: Arc<String>,
    inj_lr: Arc<String>,
}

#[derive(Default)]
struct Cdp {
    port: u16,
    tx: Option<mpsc::UnboundedSender<WsMessage>>,
    page_url: String,
    connected: bool,
    msg_id: u64,
    pending: HashMap<u64, oneshot::Sender<Result<Value, String>>>,
    events: VecDeque<(String, Value)>,
    reqs: HashMap<String, Value>,
    done_reqs: VecDeque<Value>,
    scripts: HashMap<String, String>,
    paused: Option<String>,
    prev_frames: Option<f64>,
    bps: HashMap<String, Value>,
    stop: Option<oneshot::Sender<()>>,
}
impl Cdp {
    fn emit(&mut self, t: &str, d: Value) {
        if self.events.len() >= 2000 {
            self.events.pop_front();
        }
        self.events.push_back((t.into(), d));
    }
    fn drain(&mut self) -> Vec<(String, Value)> {
        self.events.drain(..).collect()
    }
}

fn jok(v: Value) -> Response {
    (
        StatusCode::OK,
        [
            ("Content-Type", "application/json"),
            ("Access-Control-Allow-Origin", "*"),
            ("Connection", "close"),
        ],
        v.to_string(),
    )
        .into_response()
}
fn jstatus(s: StatusCode, v: Value) -> Response {
    (
        s,
        [
            ("Content-Type", "application/json"),
            ("Access-Control-Allow-Origin", "*"),
            ("Connection", "close"),
        ],
        v.to_string(),
    )
        .into_response()
}
fn jerr(s: StatusCode, m: &str) -> Response {
    jstatus(s, json!({"error": m}))
}

async fn http_json(port: u16, path: &str) -> Option<String> {
    reqwest::get(format!("http://127.0.0.1:{}{}", port, path))
        .await
        .ok()?
        .text()
        .await
        .ok()
}

async fn cdp_connect(app: Arc<App>) -> Result<Value, String> {
    let (cdp_port, srv_port) = {
        let c = app.cfg.read().await;
        (c.cdp_port, c.port)
    };
    let origin = format!("http://localhost:{}", srv_port);
    let mut body = None;
    for _ in 0..10 {
        if let Some(b) = http_json(cdp_port, "/json").await {
            body = Some(b);
            break;
        }
        sleep(Duration::from_millis(500)).await;
    }
    let body = body.ok_or_else(|| {
        format!(
            "No CDP endpoint at localhost:{} (chrome not ready after 5s wait)",
            cdp_port
        )
    })?;
    let pages: Vec<Value> = serde_json::from_str(&body).map_err(|e| e.to_string())?;
    let mut cands: Vec<Value> = pages
        .into_iter()
        .filter(|p| p.get("type").and_then(|v| v.as_str()) == Some("page"))
        .collect();
    if cands.is_empty() {
        return Err("No debuggable pages found".into());
    }
    let mut page = cands.remove(0);
    for p in &cands {
        if p.get("url")
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .starts_with(&origin)
        {
            page = p.clone();
            break;
        }
    }
    let ws_url = page
        .get("webSocketDebuggerUrl")
        .and_then(|v| v.as_str())
        .ok_or("No webSocketDebuggerUrl")?
        .to_string();
    let page_url = page
        .get("url")
        .and_then(|v| v.as_str())
        .unwrap_or("")
        .to_string();
    let (ws, _) = connect_async(&ws_url).await.map_err(|e| e.to_string())?;
    let (mut w, mut r) = ws.split();
    let (tx, mut rx) = mpsc::unbounded_channel::<WsMessage>();
    let (stop_tx, mut stop_rx) = oneshot::channel::<()>();
    let app2 = app.clone();
    tokio::spawn(async move {
        loop {
            tokio::select! { _=&mut stop_rx=>break, m=rx.recv()=>{ match m{ Some(m)=>{ if w.send(m).await.is_err(){break;} }, None=>break } } }
        }
        let _ = w.close().await;
    });
    {
        let mut g = app.cdp.lock().await;
        let c = g.get_or_insert_with(Cdp::default);
        c.port = cdp_port;
        c.tx = Some(tx.clone());
        c.page_url = page_url.clone();
        c.connected = true;
        c.msg_id = 0;
        c.pending.clear();
        c.scripts.clear();
        c.paused = None;
        c.prev_frames = None;
        c.reqs.clear();
        c.bps.clear();
        c.stop = Some(stop_tx);
        c.emit("status", json!({"state":"connected","url":page_url}));
    }
    tokio::spawn(async move {
        while let Some(m) = r.next().await {
            match m {
                Ok(WsMessage::Text(t)) => {
                    if let Ok(d) = serde_json::from_str::<Value>(&t) {
                        cdp_msg(app2.clone(), d).await;
                    }
                }
                Ok(WsMessage::Binary(b)) => {
                    if let Ok(t) = String::from_utf8(b) {
                        if let Ok(d) = serde_json::from_str::<Value>(&t) {
                            cdp_msg(app2.clone(), d).await;
                        }
                    }
                }
                Ok(WsMessage::Close(_)) | Err(_) => break,
                _ => {}
            }
        }
        let mut g = app2.cdp.lock().await;
        if let Some(c) = g.as_mut() {
            c.connected = false;
            c.tx = None;
            c.emit("status", json!({"state":"disconnected"}));
        }
    });
    for m in [
        "Runtime.enable",
        "Network.enable",
        "Debugger.enable",
        "Performance.enable",
        "Page.enable",
    ] {
        let _ = cdp_cmd(app.clone(), m, None).await;
    }
    Ok(json!({"status":"connected","url":page_url,"port":cdp_port}))
}

async fn cdp_cmd(app: Arc<App>, method: &str, params: Option<Value>) -> Result<Value, String> {
    let (rx, id) = {
        let mut g = app.cdp.lock().await;
        let c = g.as_mut().ok_or("CDP not connected")?;
        if !c.connected {
            return Err("CDP not connected".into());
        }
        let tx = c.tx.clone().ok_or("CDP not connected")?;
        c.msg_id += 1;
        let id = c.msg_id;
        let (otx, orx) = oneshot::channel();
        c.pending.insert(id, otx);
        let mut msg = json!({"id":id,"method":method});
        if let Some(p) = params {
            msg["params"] = p;
        }
        if tx.send(WsMessage::Text(msg.to_string())).is_err() {
            c.pending.remove(&id);
            return Err("CDP send failed".into());
        }
        (orx, id)
    };
    match tokio::time::timeout(Duration::from_secs(30), rx).await {
        Ok(Ok(r)) => r,
        Ok(Err(_)) => Err("CDP response channel closed".into()),
        Err(_) => {
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.pending.remove(&id);
            }
            Err(format!("CDP command {} timed out", method))
        }
    }
}

async fn cdp_msg(app: Arc<App>, d: Value) {
    if let Some(id) = d.get("id").and_then(|v| v.as_u64()) {
        let mut g = app.cdp.lock().await;
        if let Some(c) = g.as_mut() {
            if let Some(tx) = c.pending.remove(&id) {
                let _ = tx.send(if let Some(e) = d.get("error") {
                    Err(e
                        .get("message")
                        .and_then(|m| m.as_str())
                        .unwrap_or("CDP error")
                        .into())
                } else {
                    Ok(d.get("result").cloned().unwrap_or(json!({})))
                });
            }
        }
        return;
    }
    let m = d.get("method").and_then(|v| v.as_str()).unwrap_or("");
    let p = d.get("params").cloned().unwrap_or(json!({}));
    match m {
        "Runtime.consoleAPICalled" => {
            let mut msgs = vec![];
            if let Some(args) = p.get("args").and_then(|v| v.as_array()) {
                for a in args {
                    let t = a.get("type").and_then(|v| v.as_str()).unwrap_or("");
                    msgs.push(match t {
                        "string" => a
                            .get("value")
                            .and_then(|v| v.as_str())
                            .unwrap_or("")
                            .to_string(),
                        "object" => a
                            .get("description")
                            .and_then(|v| v.as_str())
                            .unwrap_or("")
                            .to_string(),
                        "number" | "boolean" => a
                            .get("value")
                            .map(|v| match v {
                                Value::String(s) => s.clone(),
                                _ => v.to_string(),
                            })
                            .unwrap_or_default(),
                        _ => a
                            .get("description")
                            .and_then(|v| v.as_str())
                            .map(|s| s.to_string())
                            .or_else(|| a.get("value").map(|v| v.to_string()))
                            .unwrap_or_default(),
                    });
                }
            }
            let level = match p.get("type").and_then(|v| v.as_str()).unwrap_or("log") {
                "warning" => "warn",
                "error" | "assert" => "error",
                "debug" => "log",
                "info" => "info",
                _ => "log",
            };
            let stack = frames(
                p.get("stackTrace")
                    .and_then(|v| v.get("callFrames"))
                    .and_then(|v| v.as_array()),
            );
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.emit("console", json!({"level":level,"message":msgs.join(" "),"timestamp":now_ts(),"stack":stack}));
            }
        }
        "Runtime.exceptionThrown" => {
            let ed = p.get("exceptionDetails").cloned().unwrap_or(json!({}));
            let exc = ed.get("exception").cloned().unwrap_or(json!({}));
            let msg = exc
                .get("description")
                .and_then(|v| v.as_str())
                .or_else(|| exc.get("value").and_then(|v| v.as_str()))
                .unwrap_or("Unknown error")
                .to_string();
            let stack = frames(
                ed.get("stackTrace")
                    .and_then(|v| v.get("callFrames"))
                    .and_then(|v| v.as_array()),
            );
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.emit(
                    "console",
                    json!({"level":"error","message":msg,"timestamp":now_ts(),"stack":stack}),
                );
            }
        }
        "Network.requestWillBeSent" => {
            let id = p
                .get("requestId")
                .and_then(|v| v.as_str())
                .unwrap_or("")
                .to_string();
            let req = p.get("request").cloned().unwrap_or(json!({}));
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.reqs.insert(id, json!({"method":req.get("method").and_then(|v|v.as_str()).unwrap_or("GET"),"url":req.get("url").and_then(|v|v.as_str()).unwrap_or(""),"start_time":epoch(),"status":Value::Null,"status_text":Value::Null,"size":Value::Null,"error":Value::Null}));
            }
        }
        "Network.responseReceived" => {
            net_done(app, p, false).await;
        }
        "Network.loadingFailed" => {
            net_done(app, p, true).await;
        }
        "Debugger.scriptParsed" => {
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.scripts.insert(
                    p.get("url").and_then(|v| v.as_str()).unwrap_or("").into(),
                    p.get("scriptId")
                        .and_then(|v| v.as_str())
                        .unwrap_or("")
                        .into(),
                );
            }
        }
        "Debugger.paused" => {
            paused(app, p).await;
        }
        "Debugger.resumed" => {
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.paused = None;
                c.emit("debugger", json!({"event":"resumed"}));
            }
        }
        "Performance.metrics" => {
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                let mut o = json!({"heap":0,"heap_total":0,"nodes":0,"listeners":0});
                if let Some(ms) = p.get("metrics").and_then(|v| v.as_array()) {
                    for m in ms {
                        let n = m.get("name").and_then(|v| v.as_str()).unwrap_or("");
                        let v = m.get("value").and_then(|v| v.as_f64()).unwrap_or(0.0);
                        match n {
                            "JSHeapUsedSize" => o["heap"] = json!(v as i64),
                            "JSHeapTotalSize" => o["heap_total"] = json!(v as i64),
                            "Nodes" => o["nodes"] = json!(v as i64),
                            "JSEventListeners" => o["listeners"] = json!(v as i64),
                            "Frames" => {
                                if let Some(prev) = c.prev_frames {
                                    o["fps"] = json!(((v - prev).round() as i64).clamp(0, 1000));
                                }
                                c.prev_frames = Some(v);
                            }
                            _ => {}
                        }
                    }
                }
                c.emit("perf", o);
            }
        }
        _ => {}
    }
}
fn frames(arr: Option<&Vec<Value>>) -> Vec<Value> {
    arr.map(|a| a.iter().map(|f| json!({"function":f.get("functionName").and_then(|v|v.as_str()).unwrap_or("<anon>"),"url":f.get("url").and_then(|v|v.as_str()).unwrap_or(""),"line":f.get("lineNumber").and_then(|v|v.as_i64()).unwrap_or(0)+1,"column":f.get("columnNumber").and_then(|v|v.as_i64()).unwrap_or(0)+1})).collect()).unwrap_or_default()
}
async fn net_done(app: Arc<App>, p: Value, failed: bool) {
    let id = p
        .get("requestId")
        .and_then(|v| v.as_str())
        .unwrap_or("")
        .to_string();
    let mut g = app.cdp.lock().await;
    let Some(c) = g.as_mut() else {
        return;
    };
    let Some(mut req) = c.reqs.remove(&id) else {
        return;
    };
    let end = epoch();
    let start = req
        .get("start_time")
        .and_then(|v| v.as_f64())
        .unwrap_or(end);
    let dur = ((end - start) * 1000.0 * 10.0).round() / 10.0;
    req["end_time"] = json!(end);
    req["duration_ms"] = json!(dur);
    if failed {
        req["status"] = json!(0);
        req["error"] = p.get("errorText").cloned().unwrap_or(json!("Failed"));
    } else {
        let r = p.get("response").cloned().unwrap_or(json!({}));
        req["status"] = r.get("status").cloned().unwrap_or(json!(0));
        req["status_text"] = r.get("statusText").cloned().unwrap_or(json!(""));
        req["size"] = r
            .get("encodedDataLength")
            .cloned()
            .or_else(|| r.get("transferSize").cloned())
            .unwrap_or(json!(0));
        req["mime"] = r.get("mimeType").cloned().unwrap_or(json!(""));
        req["type"] = p.get("type").cloned().unwrap_or(json!(""));
    }
    let e = req.clone();
    if c.done_reqs.len() >= 500 {
        c.done_reqs.pop_front();
    }
    c.done_reqs.push_back(e.clone());
    let mut ev = json!({"method":e.get("method").cloned().unwrap_or(json!("GET")),"url":e.get("url").cloned().unwrap_or(json!("")),"status":e.get("status").cloned().unwrap_or(json!(0)),"duration":e.get("duration_ms").cloned().unwrap_or(json!(0))});
    if failed {
        ev["error"] = e.get("error").cloned().unwrap_or(json!("Failed"));
    } else {
        ev["size"] = e.get("size").cloned().unwrap_or(Value::Null);
        ev["mime"] = e.get("mime").cloned().unwrap_or(json!(""));
        ev["type"] = e.get("type").cloned().unwrap_or(json!(""));
    }
    c.emit("network", ev);
}
fn fmt_remote(o: &Value) -> String {
    if !o.is_object() {
        return o.to_string();
    }
    let t = o
        .get("type")
        .and_then(|v| v.as_str())
        .unwrap_or("undefined");
    if let Some(v) = o.get("value") {
        if t == "string" {
            return format!("{:?}", v.as_str().unwrap_or(&v.to_string()));
        }
        return match v {
            Value::String(s) => s.clone(),
            _ => v.to_string(),
        };
    }
    if let Some(u) = o.get("unserializableValue") {
        return u.as_str().unwrap_or(&u.to_string()).to_string();
    }
    o.get("description")
        .and_then(|v| v.as_str())
        .map(|s| s.to_string())
        .unwrap_or_else(|| format!("[{}]", t))
}
async fn scopes(app: Arc<App>, frame: &Value) -> Value {
    let mut out = vec![];
    if let Some(ch) = frame.get("scopeChain").and_then(|v| v.as_array()) {
        for sc in ch {
            let st = sc.get("type").and_then(|v| v.as_str()).unwrap_or("unknown");
            if st == "global" {
                continue;
            }
            let oid = sc
                .get("object")
                .and_then(|o| o.get("objectId"))
                .and_then(|v| v.as_str())
                .map(|s| s.to_string());
            let mut props = vec![];
            if let Some(oid) = oid {
                if let Ok(res) = cdp_cmd(
                    app.clone(),
                    "Runtime.getProperties",
                    Some(json!({"objectId":oid,"ownProperties":true,"generatePreview":false})),
                )
                .await
                {
                    if let Some(a) = res.get("result").and_then(|v| v.as_array()) {
                        for p in a.iter().take(30) {
                            let n = p.get("name").and_then(|v| v.as_str()).unwrap_or("?");
                            if n == "__proto__" {
                                continue;
                            }
                            props.push(json!({"name":n,"value":fmt_remote(p.get("value").unwrap_or(&json!({})))}));
                        }
                    }
                }
            }
            if !props.is_empty() || ["local", "closure", "block", "catch"].contains(&st) {
                out.push(json!({"type":st,"props":props}));
            }
        }
    }
    json!({"this":fmt_remote(frame.get("this").unwrap_or(&json!({}))), "scopes":out})
}
async fn paused(app: Arc<App>, p: Value) {
    let raw = p
        .get("callFrames")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let mut frames = vec![];
    for f in &raw {
        let l = f.get("location").cloned().unwrap_or(json!({}));
        frames.push(json!({"function":f.get("functionName").and_then(|v|v.as_str()).unwrap_or("<anon>"),"url":f.get("url").and_then(|v|v.as_str()).unwrap_or(""),"line":l.get("lineNumber").and_then(|v|v.as_i64()).unwrap_or(0)+1,"column":l.get("columnNumber").and_then(|v|v.as_i64()).unwrap_or(0)+1,"scriptId":l.get("scriptId").and_then(|v|v.as_str()).unwrap_or("")}));
    }
    let fid = raw
        .first()
        .and_then(|f| f.get("callFrameId"))
        .and_then(|v| v.as_str())
        .map(|s| s.to_string());
    let si = if let Some(f) = raw.first() {
        scopes(app.clone(), f).await
    } else {
        json!({"this":"undefined","scopes":[]})
    };
    let mut g = app.cdp.lock().await;
    if let Some(c) = g.as_mut() {
        c.paused = fid;
        let mut ev = json!({"event":"paused","reason":p.get("reason").and_then(|v|v.as_str()).unwrap_or("other"),"callFrames":frames});
        if let (Some(o), Some(s)) = (ev.as_object_mut(), si.as_object()) {
            for (k, v) in s {
                o.insert(k.clone(), v.clone());
            }
        }
        c.emit("debugger", ev);
    }
}
async fn cdp_disconnect(app: Arc<App>) {
    let mut g = app.cdp.lock().await;
    if let Some(c) = g.as_mut() {
        c.connected = false;
        c.paused = None;
        c.prev_frames = None;
        c.reqs.clear();
        c.bps.clear();
        c.tx = None;
        if let Some(t) = c.stop.take() {
            let _ = t.send(());
        }
        c.emit("status", json!({"state":"disconnected"}));
    }
}

fn resolve_script(c: &Cdp, name: &str) -> Option<String> {
    if name.is_empty() {
        return None;
    }
    if let Some(s) = c.scripts.get(name) {
        return Some(s.clone());
    }
    let tail = name.rsplit('/').next().unwrap_or(name);
    c.scripts
        .iter()
        .find(|(u, _)| u.rsplit('/').next().unwrap_or(u) == tail)
        .map(|(_, s)| s.clone())
}
fn abs_url(page: &str, name: &str) -> String {
    if name.contains("://") {
        return name.into();
    }
    let p = if page.is_empty() {
        "http://localhost:8000/"
    } else {
        page
    };
    if let Some((s, r)) = p.split_once("://") {
        let h = r.split('/').next().unwrap_or(r);
        return format!("{}://{}/{}", s, h, name.trim_start_matches('/'));
    }
    name.into()
}

fn mime(p: &str) -> &'static str {
    match FsPath::new(p)
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("")
    {
        "html" => "text/html",
        "js" => "text/javascript",
        "css" => "text/css",
        "json" => "application/json",
        "png" => "image/png",
        "jpg" | "jpeg" => "image/jpeg",
        "gif" => "image/gif",
        "svg" => "image/svg+xml",
        "ico" => "image/x-icon",
        "woff" => "application/font-woff",
        "woff2" => "font/woff2",
        "ttf" => "application/font-ttf",
        _ => "application/octet-stream",
    }
}

fn cache_dir() -> Option<PathBuf> {
    if let Ok(xdg) = std::env::var("XDG_CACHE_HOME") {
        if !xdg.is_empty() {
            return Some(PathBuf::from(xdg).join("p5.nvim"));
        }
    }
    std::env::var("HOME")
        .ok()
        .map(|h| PathBuf::from(h).join(".cache/p5.nvim"))
}

fn sketch_p5_version(dir: &FsPath) -> String {
    if let Ok(s) = std::fs::read_to_string(dir.join("p5.json")) {
        if let Ok(v) = serde_json::from_str::<Value>(&s) {
            if let Some(ver) = v.get("version").and_then(|x| x.as_str()) {
                if !ver.is_empty() {
                    return ver.to_string();
                }
            }
        }
    }
    "2.3.1".to_string()
}

fn libs_loader_js() -> &'static str {
    r#"// Auto-generated - reads libraries from p5.json at runtime
(function() {
  function loadLibs() {
    fetch('p5.json')
      .then(function(response) { return response.json(); })
      .then(function(config) {
        var libsObj = config.libs || {};
        var libs = Object.keys(libsObj);
        return loadLibsSequential(libs, 0);
      })
      .catch(function(err) {
        console.warn('Could not load p5.json:', err);
      });
  }

  function loadLibsSequential(libs, index) {
    if (index >= libs.length) return Promise.resolve();

    var lib = libs[index];
    if (lib === 'p5' || lib === 'p5.sound') {
      return loadLibsSequential(libs, index + 1);
    }

    return new Promise(function(resolve) {
      var script = document.createElement('script');
      script.src = 'assets/libs/' + lib + '.js';
      script.onload = function() {
        console.log('Loaded: ' + lib);
        resolve();
      };
      script.onerror = function() {
        console.warn('Failed to load: ' + lib);
        resolve();
      };
      document.head.appendChild(script);
    }).then(function() {
      return loadLibsSequential(libs, index + 1);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadLibs);
  } else {
    loadLibs();
  }
})();
"#
}

fn asset_fallback_bytes(app: &App, req_path: &str) -> Option<(Vec<u8>, &'static str)> {
    if req_path == "/assets/favicon.ico" || req_path == "/favicon.ico" {
        let root = plugin_root();
        let p = root.join("assets/favicon.ico");
        if let Ok(b) = std::fs::read(p) {
            return Some((b, "image/x-icon"));
        }
    }
    if req_path == "/assets/libs/libs.js" {
        return Some((libs_loader_js().as_bytes().to_vec(), "text/javascript"));
    }
    if req_path == "/assets/libs/p5.js" {
        let ver = sketch_p5_version(&app.dir);
        if let Some(cd) = cache_dir() {
            let p = cd.join("versions").join(ver).join("p5.js");
            if let Ok(b) = std::fs::read(p) {
                return Some((b, "text/javascript"));
            }
        }
    }
    None
}

async fn gen_index(dir: &FsPath) -> String {
    let mut cfg = json!({});
    if let Ok(s) = tokio::fs::read_to_string(dir.join("p5.json")).await {
        if let Ok(v) = serde_json::from_str::<Value>(&s) {
            cfg = v;
        }
    }
    let libs = cfg
        .get("libs")
        .and_then(|v| v.as_object())
        .cloned()
        .unwrap_or_default();
    let title = cfg
        .get("gist")
        .and_then(|g| g.get("title"))
        .and_then(|v| v.as_str())
        .unwrap_or("p5.js Sketch");
    let sketch = dir.join("sketch.js");
    if !sketch.is_file() {
        let _=tokio::fs::write(&sketch,"function setup() {\n  createCanvas(400, 400);\n}\n\nfunction draw() {\n  background(220);\n  circle(mouseX, mouseY, 50);\n}").await;
    }
    let mut scripts = vec!["  <script src=\"assets/libs/p5.js\"></script>".to_string()];
    for (n, _) in &libs {
        scripts.push(format!("  <script src=\"assets/libs/{}.js\"></script>", n));
    }
    scripts.push("  <script src=\"assets/libs/libs.js\"></script>".into());
    format!("<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n  <meta charset=\"UTF-8\">\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n  <title>{}</title>\n  <link rel=\"icon\" type=\"image/x-icon\" href=\"assets/favicon.ico\">\n{}\n</head>\n<body>\n  <main>\n  </main>\n  <script src=\"sketch.js\"></script>\n</body>\n</html>", title, scripts.join("\n"))
}
async fn inject(app: &App, html: Vec<u8>) -> Vec<u8> {
    let mut s = String::from_utf8_lossy(&html).to_string();
    if let Ok(t) = tokio::fs::read_to_string(app.dir.join("p5.json")).await {
        if let Ok(cfg) = serde_json::from_str::<Value>(&t) {
            if let Some(title) = cfg
                .get("gist")
                .and_then(|g| g.get("title"))
                .and_then(|v| v.as_str())
            {
                if !title.is_empty() {
                    if let Ok(re) = RegexBuilder::new("<title>[^<]*</title>")
                        .case_insensitive(true)
                        .build()
                    {
                        s = re
                            .replace(&s, format!("<title>{}</title>", title))
                            .to_string();
                    }
                }
            }
        }
    }
    let active = app
        .cdp
        .lock()
        .await
        .as_ref()
        .map(|c| c.connected)
        .unwrap_or(false);
    let mut inj = format!(
        "<script>window.__P5_CDP_ACTIVE = {};</script><script>{}</script>",
        if active { "true" } else { "false" },
        app.inj_console
    );
    if app.cfg.read().await.lr_enabled && !app.inj_lr.is_empty() {
        let p = *app.lr_port.read().await;
        inj.push_str(&format!(
            "<script>{}</script>",
            app.inj_lr.replace("__LR_PORT__", &p.to_string())
        ));
    }
    if let Ok(re) = RegexBuilder::new("</body>").case_insensitive(true).build() {
        s = if re.is_match(&s) {
            re.replace(&s, format!("{}</body>", inj)).to_string()
        } else {
            format!("{}{}", s, inj)
        };
    } else {
        s.push_str(&inj);
    }
    s.into_bytes()
}

async fn serve(app: Arc<App>, method: Method, uri: Uri) -> Response {
    if method != Method::GET {
        return (
            StatusCode::METHOD_NOT_ALLOWED,
            [("Connection", "close")],
            "",
        )
            .into_response();
    }
    let mut path = uri.path().to_string();
    if path == "/" {
        path = "/index.html".into();
    }
    let rel = path.trim_start_matches('/');
    let joined = app.dir.join(rel);
    let base = app.dir.canonicalize().unwrap_or(app.dir.clone());
    if let Ok(r) = joined.canonicalize() {
        if !r.starts_with(&base) {
            return (StatusCode::FORBIDDEN, [("Connection", "close")], "").into_response();
        }
    } else if path != "/index.html" && joined.exists() {
        return (StatusCode::BAD_REQUEST, [("Connection", "close")], "").into_response();
    }
    let fp = if path == "/index.html" {
        app.dir.join("index.html")
    } else {
        joined
    };
    if path == "/index.html" && !fp.is_file() {
        let html = gen_index(&app.dir).await;
        let out = inject(&app, html.into_bytes()).await;
        return Response::builder()
            .status(200)
            .header("Content-Type", "text/html")
            .header("Content-Length", out.len())
            .header("Access-Control-Allow-Origin", "*")
            .header("Connection", "close")
            .body(Body::from(out))
            .unwrap();
    }
    if !fp.is_file() {
        if let Some((b, ct)) = asset_fallback_bytes(&app, &path) {
            return Response::builder()
                .status(200)
                .header("Content-Type", ct)
                .header("Content-Length", b.len())
                .header("Access-Control-Allow-Origin", "*")
                .header("Cache-Control", "no-store")
                .header("Connection", "close")
                .body(Body::from(b))
                .unwrap();
        }
        return (
            StatusCode::NOT_FOUND,
            [
                ("Content-Type", "text/plain"),
                ("Access-Control-Allow-Origin", "*"),
                ("Connection", "close"),
            ],
            "File not found",
        )
            .into_response();
    }
    match tokio::fs::read(&fp).await {
        Ok(mut b) => {
            let ext = fp.extension().and_then(|e| e.to_str()).unwrap_or("");
            if ext == "html" {
                b = inject(&app, b).await;
            }
            Response::builder()
                .status(200)
                .header("Content-Type", mime(&format!("x.{}", ext)))
                .header("Content-Length", b.len())
                .header("Access-Control-Allow-Origin", "*")
                .header("Connection", "close")
                .body(Body::from(b))
                .unwrap()
        }
        Err(_) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            [("Connection", "close")],
            "An error occurred while processing your request",
        )
            .into_response(),
    }
}

fn stream<St, F, Fut>(
    init: St,
    step: F,
) -> impl futures_util::Stream<Item = Result<bytes::Bytes, std::convert::Infallible>>
where
    F: FnMut(St) -> Fut,
    Fut: std::future::Future<Output = Option<(Result<bytes::Bytes, std::convert::Infallible>, St)>>,
{
    futures_util::stream::unfold(init, step)
}

async fn console_log(State(app): State<Arc<App>>, body: bytes::Bytes) -> Response {
    match serde_json::from_slice::<Value>(&body) {
        Ok(mut v) => {
            let mut b = app.console.lock().await;
            if v.get("type").and_then(|x| x.as_str()) == Some("console_batch") {
                if let Some(logs) = v.get_mut("logs").and_then(|x| x.as_array_mut()) {
                    for e in logs.iter_mut() {
                        if e.get("timestamp").is_none() {
                            e["timestamp"] = json!(now_iso());
                        }
                        b.push(e.clone());
                    }
                }
            } else {
                if v.get("timestamp").is_none() {
                    v["timestamp"] = json!(now_iso());
                }
                b.push(v);
            }
            jok(json!({"status":"received"}))
        }
        Err(_) => jerr(StatusCode::BAD_REQUEST, "Invalid request"),
    }
}
async fn console_stream(State(app): State<Arc<App>>) -> Response {
    let s = stream(
        (app, 15i32, 15i32, 300i32, 0i32),
        |(app, base, mut cur, max, mut hb)| async move {
            loop {
                let logs = { app.console.lock().await.drain() };
                let mut out = String::new();
                if !logs.is_empty() {
                    cur = base;
                    hb = 0;
                    for e in logs {
                        out.push_str(&format!(
                            "data: {}\n\n",
                            format_log(
                                e.get("level").and_then(|v| v.as_str()).unwrap_or("log"),
                                e.get("message").and_then(|v| v.as_str()).unwrap_or(""),
                                e.get("source")
                                    .and_then(|v| v.as_str())
                                    .unwrap_or("browser")
                            )
                        ));
                    }
                }
                hb += 1;
                if hb >= cur {
                    hb = 0;
                    out.push_str(": heartbeat\n\n");
                    cur = (cur * 2).min(max);
                }
                if !out.is_empty() {
                    return Some((Ok(bytes::Bytes::from(out)), (app, base, cur, max, hb)));
                }
                sleep(Duration::from_secs(1)).await;
            }
        },
    );
    Response::builder()
        .status(200)
        .header("Content-Type", "text/plain; charset=utf-8")
        .header("Cache-Control", "no-cache")
        .header("Access-Control-Allow-Origin", "*")
        .header("Connection", "keep-alive")
        .header("X-Accel-Buffering", "no")
        .body(Body::from_stream(s))
        .unwrap()
}
async fn cdp_stream_h(State(app): State<Arc<App>>) -> Response {
    let s = stream((app, 0i32), |(app, mut hb)| async move {
        loop {
            let connected = app
                .cdp
                .lock()
                .await
                .as_ref()
                .map(|c| c.connected)
                .unwrap_or(false);
            if connected {
                let evs = {
                    app.cdp
                        .lock()
                        .await
                        .as_mut()
                        .map(|c| c.drain())
                        .unwrap_or_default()
                };
                if !evs.is_empty() {
                    let mut out = String::new();
                    for (t, mut d) in evs {
                        if let Some(o) = d.as_object_mut() {
                            o.entry("type").or_insert(Value::String(t));
                        } else {
                            d = json!({"type": t, "data": d});
                        }
                        out.push_str(&d.to_string());
                        out.push('\n');
                    }
                    return Some((Ok(bytes::Bytes::from(out)), (app, 0)));
                }
                hb += 1;
                if hb >= 15 {
                    return Some((Ok(bytes::Bytes::from("{\"type\":\"hb\"}\n")), (app, 0)));
                }
            } else {
                let logs = { app.console.lock().await.drain() };
                if !logs.is_empty() {
                    let mut out = String::new();
                    for mut e in logs {
                        if e.get("stack").is_none() {
                            e["stack"] = json!([]);
                        }
                        e["type"] = json!("console");
                        out.push_str(&e.to_string());
                        out.push('\n');
                    }
                    return Some((Ok(bytes::Bytes::from(out)), (app, 0)));
                }
                if hb == 0 {
                    return Some((
                        Ok(bytes::Bytes::from(
                            "{\"type\":\"status\",\"state\":\"disconnected\"}\n",
                        )),
                        (app, 1),
                    ));
                }
                hb += 1;
                if hb >= 15 {
                    return Some((Ok(bytes::Bytes::from("{\"type\":\"hb\"}\n")), (app, 0)));
                }
            }
            sleep(Duration::from_secs(1)).await;
        }
    });
    Response::builder()
        .status(200)
        .header("Content-Type", "application/x-ndjson")
        .header("Cache-Control", "no-cache")
        .header("Access-Control-Allow-Origin", "*")
        .header("Connection", "keep-alive")
        .header("X-Accel-Buffering", "no")
        .body(Body::from_stream(s))
        .unwrap()
}

async fn need_cdp(app: &Arc<App>) -> Result<(), Response> {
    if app
        .cdp
        .lock()
        .await
        .as_ref()
        .map(|c| c.connected)
        .unwrap_or(false)
    {
        Ok(())
    } else {
        Err(jerr(StatusCode::SERVICE_UNAVAILABLE, "CDP not connected"))
    }
}
fn parse_body(b: bytes::Bytes) -> Result<Value, Response> {
    serde_json::from_slice(&b).map_err(|e| jerr(StatusCode::BAD_REQUEST, &e.to_string()))
}

async fn cdp_route(
    State(app): State<Arc<App>>,
    method: Method,
    uri: Uri,
    body: bytes::Bytes,
) -> Response {
    let p = uri.path();
    match (method.as_str(), p) {
        ("POST", "/api/cdp/connect") => {
            let a = {
                app.cdp
                    .lock()
                    .await
                    .as_ref()
                    .map(|c| (c.connected, c.page_url.clone()))
            };
            if let Some((true, u)) = a {
                return jok(json!({"status":"already_connected","url":u}));
            }
            cdp_disconnect(app.clone()).await;
            match cdp_connect(app.clone()).await {
                Ok(v) => jok(v),
                Err(e) => {
                    cdp_disconnect(app).await;
                    jstatus(
                        StatusCode::SERVICE_UNAVAILABLE,
                        json!({"status":"error","message":e}),
                    )
                }
            }
        }
        ("DELETE", "/api/cdp/connect") => {
            if app
                .cdp
                .lock()
                .await
                .as_ref()
                .map(|c| c.connected)
                .unwrap_or(false)
            {
                cdp_disconnect(app).await;
                jok(json!({"status":"disconnected"}))
            } else {
                jok(json!({"status":"not_connected"}))
            }
        }
        ("GET", "/api/cdp/status") => {
            let g = app.cdp.lock().await;
            if let Some(c) = g.as_ref() {
                if c.connected {
                    return jok(json!({"connected":true,"url":c.page_url}));
                }
            }
            jok(json!({"connected":false}))
        }
        ("GET", "/api/cdp/stream") => cdp_stream_h(State(app)).await,
        ("POST", "/api/cdp/evaluate") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            let d = match parse_body(body) {
                Ok(d) => d,
                Err(r) => return r,
            };
            let expr = d.get("expression").and_then(|v| v.as_str()).unwrap_or("");
            let rbv = d
                .get("returnByValue")
                .and_then(|v| v.as_bool())
                .unwrap_or(true);
            let paused = app.cdp.lock().await.as_ref().and_then(|c| c.paused.clone());
            let res = if let Some(fid) = paused {
                let mut p = json!({"callFrameId":fid,"expression":expr,"returnByValue":rbv,"includeCommandLineAPI":true});
                if !rbv {
                    p["generatePreview"] = json!(true);
                }
                cdp_cmd(app, "Debugger.evaluateOnCallFrame", Some(p)).await
            } else {
                let mut p =
                    json!({"expression":expr,"returnByValue":rbv,"includeCommandLineAPI":true});
                if !rbv {
                    p["generatePreview"] = json!(true);
                }
                cdp_cmd(app, "Runtime.evaluate", Some(p)).await
            };
            match res {
                Ok(v) => jok(v),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/properties") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            let d = match parse_body(body) {
                Ok(d) => d,
                Err(r) => return r,
            };
            let oid = d.get("objectId").and_then(|v| v.as_str()).unwrap_or("");
            match cdp_cmd(
                app,
                "Runtime.getProperties",
                Some(json!({"objectId":oid,"ownProperties":true,"generatePreview":true})),
            )
            .await
            {
                Ok(v) => jok(v),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/break") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            let d = match parse_body(body) {
                Ok(d) => d,
                Err(r) => return r,
            };
            let loc = d.get("location").and_then(|v| v.as_str()).unwrap_or("");
            let parts: Vec<&str> = loc.rsplitn(2, ':').collect();
            if parts.len() != 2 {
                return jerr(StatusCode::BAD_REQUEST, "Use format: file.js:line");
            }
            let line: i64 = parts[0].parse().unwrap_or(0);
            let url = parts[1].to_string();
            let (sid, page) = {
                let g = app.cdp.lock().await;
                (
                    g.as_ref().and_then(|c| resolve_script(c, &url)),
                    g.as_ref().map(|c| c.page_url.clone()).unwrap_or_default(),
                )
            };
            let res = if let Some(sid) = sid {
                cdp_cmd(
                    app.clone(),
                    "Debugger.setBreakpoint",
                    Some(json!({"location":{"scriptId":sid,"lineNumber":line-1}})),
                )
                .await
                .map(|mut r| {
                    r["resolved"] = json!(if r.get("actualLocation").is_some() {
                        1
                    } else {
                        0
                    });
                    r
                })
            } else {
                let abs = abs_url(&page, &url);
                cdp_cmd(
                    app.clone(),
                    "Debugger.setBreakpointByUrl",
                    Some(json!({"url":abs,"lineNumber":line-1})),
                )
                .await
                .map(|mut r| {
                    r["resolved"] = json!(r
                        .get("locations")
                        .and_then(|v| v.as_array())
                        .map(|a| a.len())
                        .unwrap_or(0));
                    r
                })
            };
            match res {
                Ok(mut r) => {
                    r["location"] = json!(loc);
                    if let Some(bid) = r.get("breakpointId").and_then(|v| v.as_str()) {
                        let mut g = app.cdp.lock().await;
                        if let Some(c) = g.as_mut() {
                            c.bps.insert(bid.into(), json!({"id":bid,"location":loc}));
                        }
                    }
                    jok(r)
                }
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/remove") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            let d = match parse_body(body) {
                Ok(d) => d,
                Err(r) => return r,
            };
            let bid = d.get("breakpointId").and_then(|v| v.as_str()).unwrap_or("");
            match cdp_cmd(
                app.clone(),
                "Debugger.removeBreakpoint",
                Some(json!({"breakpointId":bid})),
            )
            .await
            {
                Ok(_) => {
                    let mut g = app.cdp.lock().await;
                    if let Some(c) = g.as_mut() {
                        c.bps.remove(bid);
                    }
                    jok(json!({"status":"removed","breakpointId":bid}))
                }
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("GET", "/api/cdp/debug/breakpoints") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            let bps = app
                .cdp
                .lock()
                .await
                .as_ref()
                .map(|c| c.bps.values().cloned().collect::<Vec<_>>())
                .unwrap_or_default();
            jok(json!({"breakpoints":bps}))
        }
        ("POST", "/api/cdp/debug/continue") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Debugger.resume", None).await {
                Ok(_) => jok(json!({"status":"resumed"})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/pause") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Debugger.pause", None).await {
                Ok(_) => jok(json!({"status":"pausing"})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/pauseExceptions") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            let d = match parse_body(body) {
                Ok(d) => d,
                Err(r) => return r,
            };
            let st = d.get("state").and_then(|v| v.as_str()).unwrap_or("none");
            if !["none", "uncaught", "all"].contains(&st) {
                return jerr(
                    StatusCode::BAD_REQUEST,
                    "state must be one of: none, uncaught, all",
                );
            }
            match cdp_cmd(
                app,
                "Debugger.setPauseOnExceptions",
                Some(json!({"state":st})),
            )
            .await
            {
                Ok(_) => jok(json!({"status":format!("pause_on_exceptions={}",st)})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/step") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Debugger.stepOver", None).await {
                Ok(_) => jok(json!({"status":"stepped"})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/stepIn") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Debugger.stepInto", None).await {
                Ok(_) => jok(json!({"status":"stepped_in"})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("POST", "/api/cdp/debug/stepOut") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Debugger.stepOut", None).await {
                Ok(_) => jok(json!({"status":"stepped_out"})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("DELETE", "/api/cdp/network") => {
            let mut g = app.cdp.lock().await;
            if let Some(c) = g.as_mut() {
                c.done_reqs.clear();
            }
            jok(json!({"status":"cleared"}))
        }
        ("POST", "/api/cdp/page/reload") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Page.reload", Some(json!({"ignoreCache":true}))).await {
                Ok(_) => jok(json!({"status":"reloading"})),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        ("GET", "/api/cdp/page/screenshot") => {
            if let Err(r) = need_cdp(&app).await {
                return r;
            }
            match cdp_cmd(app, "Page.captureScreenshot", Some(json!({"format":"png"}))).await {
                Ok(v) => jok(v),
                Err(e) => jerr(StatusCode::BAD_REQUEST, &e),
            }
        }
        _ => jerr(StatusCode::NOT_FOUND, "Unknown CDP endpoint"),
    }
}

async fn lr_ws(ws: WebSocketUpgrade, State(app): State<Arc<App>>) -> Response {
    ws.on_upgrade(move |s| lr_conn(s, app))
}
async fn lr_conn(mut s: WebSocket, app: Arc<App>) {
    let (tx, mut rx) = mpsc::unbounded_channel::<String>();
    app.lr_clients.lock().await.push(tx);
    let _ = s
        .send(Message::Text(
            json!({"type":"connected","message":"Live reload connected"}).to_string(),
        ))
        .await;
    loop {
        tokio::select! { m=rx.recv()=>{ match m{ Some(m)=>{ if s.send(Message::Text(m)).await.is_err(){break;} }, None=>break } }, i=s.recv()=>{ match i{ Some(Ok(_))=>{}, _=>break } } }
    }
}

async fn watch(app: Arc<App>, dir: PathBuf) {
    let (ext, ex, debounce) = {
        let c = app.cfg.read().await;
        (
            c.lr_ext.clone(),
            c.lr_ex.clone(),
            c.lr_debounce as f64 / 1000.0,
        )
    };
    let mut last: HashMap<PathBuf, std::time::SystemTime> = HashMap::new();
    let mut pending: HashMap<PathBuf, f64> = HashMap::new();
    let mut last_fire = 0.0;
    let mut initialized = false;
    loop {
        let mut cur: HashMap<PathBuf, std::time::SystemTime> = HashMap::new();
        let mut st = vec![dir.clone()];
        while let Some(d) = st.pop() {
            let mut rd = match tokio::fs::read_dir(&d).await {
                Ok(r) => r,
                Err(_) => continue,
            };
            while let Ok(Some(e)) = rd.next_entry().await {
                let p = e.path();
                let name = e.file_name().to_string_lossy().to_string();
                let ft = match e.file_type().await {
                    Ok(f) => f,
                    Err(_) => continue,
                };
                if ft.is_dir() {
                    if ex.iter().any(|x| x == &name) {
                        continue;
                    }
                    st.push(p);
                } else if ft.is_file() {
                    if ex.iter().any(|x| {
                        p.components()
                            .any(|c| c.as_os_str().to_string_lossy() == *x)
                    }) {
                        continue;
                    }
                    let ps = p.to_string_lossy().to_string();
                    if ext.iter().any(|x| ps.ends_with(x)) {
                        if let Ok(md) = e.metadata().await {
                            if let Ok(mt) = md.modified() {
                                cur.insert(p, mt);
                            }
                        }
                    }
                }
            }
        }
        let now = epoch();
        if initialized {
            for (p, mt) in &cur {
                match last.get(p) {
                    Some(prev) if prev != mt => {
                        pending.entry(p.clone()).or_insert(now);
                    }
                    None => {
                        pending.entry(p.clone()).or_insert(now);
                    }
                    _ => {}
                }
            }
            let pending_keys: Vec<_> = pending.keys().cloned().collect();
            for p in pending_keys {
                if !cur.contains_key(&p) {
                    pending.remove(&p);
                }
            }
            let mut fire = vec![];
            if now - last_fire >= debounce {
                let keys: Vec<_> = pending.keys().cloned().collect();
                for p in keys {
                    let ct = *pending.get(&p).unwrap_or(&now);
                    let stable = match (cur.get(&p), last.get(&p)) {
                        (Some(cu), Some(pr)) => cu == pr,
                        (Some(_), None) => true,
                        _ => false,
                    };
                    if stable && (now - ct) >= debounce {
                        pending.remove(&p);
                        fire.push(p);
                    }
                }
                if !fire.is_empty() {
                    last_fire = now;
                }
            }
            for p in fire {
                let msg =
                    json!({"type":"reload","file":p.to_string_lossy(),"timestamp":now_iso()})
                        .to_string();
                {
                    let mut cs = app.lr_clients.lock().await;
                    cs.retain(|tx| tx.send(msg.clone()).is_ok());
                }
                println!("Reload triggered for: {}", p.to_string_lossy());
            }
        } else {
            initialized = true;
            last_fire = now;
        }
        last = cur;
        sleep(Duration::from_millis(300)).await;
    }
}

async fn root(
    State(app): State<Arc<App>>,
    method: Method,
    uri: Uri,
    body: bytes::Bytes,
) -> Response {
    let path = uri.path();
    if method == Method::POST && path == "/api/console/log" {
        return console_log(State(app), body).await;
    }
    if method == Method::GET && path == "/api/console/stream" {
        return console_stream(State(app)).await;
    }
    if method == Method::GET && path == "/api/health" {
        let c = app.cfg.read().await;
        return jok(
            json!({"status":"ok","server":"p5.nvim asyncio","port":c.port,"console_buffer_size":app.console.lock().await.len()}),
        );
    }
    if path.starts_with("/api/cdp/") {
        return cdp_route(State(app), method, uri, body).await;
    }
    serve(app, method, uri).await
}

#[tokio::main]
async fn main() {
    let cfg = parse_args();
    let dir = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    let proot = plugin_root();
    let app = Arc::new(App {
        lr_port: Arc::new(RwLock::new(cfg.lr_port)),
        lr_clients: Arc::new(Mutex::new(vec![])),
        console: Arc::new(Mutex::new(ConsoleBuf::new(1000))),
        cdp: Arc::new(Mutex::new(None)),
        inj_console: Arc::new(read_inject(&proot, "console.js")),
        inj_lr: Arc::new(read_inject(&proot, "livereload.js")),
        dir: dir.clone(),
        cfg: Arc::new(RwLock::new(cfg.clone())),
    });
    if cfg.lr_enabled {
        if let Some((l, p)) = try_bind(cfg.lr_port).await {
            *app.lr_port.write().await = p;
            app.cfg.write().await.lr_port = p;
            println!("Live reload WebSocket running on ws://localhost:{}", p);
            let r = Router::new().route("/", get(lr_ws)).with_state(app.clone());
            tokio::spawn(async move {
                let _ = axum::serve(l, r).await;
            });
        } else {
            println!("Warning: Could not start live reload server");
        }
    }
    let Some((l, p)) = try_bind(cfg.port).await else {
        println!("Error starting server on port {}", cfg.port);
        std::process::exit(1);
    };
    app.cfg.write().await.port = p;
    println!("Server running at http://localhost:{}/", p);
    if cfg.lr_enabled {
        let a = app.clone();
        tokio::spawn(async move {
            watch(a, dir).await;
        });
    }
    let router = Router::new().fallback(root).with_state(app.clone());
    let srv = axum::serve(l, router).with_graceful_shutdown(async {
        let ctrl = async {
            let _ = tokio::signal::ctrl_c().await;
        };
        #[cfg(unix)]
        let term = async {
            use tokio::signal::unix::{signal, SignalKind};
            if let Ok(mut s) = signal(SignalKind::terminate()) {
                s.recv().await;
            } else {
                std::future::pending::<()>().await;
            }
        };
        #[cfg(not(unix))]
        let term = std::future::pending::<()>();
        tokio::select! { _=ctrl=>{}, _=term=>{} }
        println!("\nShutting down server...");
    });
    if let Err(e) = srv.await {
        eprintln!("server error: {}", e);
    }
    println!("Closing connections...");
    cdp_disconnect(app).await;
    println!("Server stopped");
}
