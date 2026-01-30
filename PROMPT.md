Create a neovim plugin for p5js that:

- Creates new projects with types and core modules installed for perfect support of p5 global mode download types from definitely typed
- Allow the user to download all the available contributor libraries from CDNs
- Allows the user to start a live server using auto detection of the available options which are python, bun,deno or live-server. Put the code for starting live servers in dedicated scripts
- Allow the user to see browser (DOM errors etc) logs from the terminal whenever a p5 live server is running from a toggleable terminal window.
- Allow the user to upload their sketchspace as a Gist using the gh cli

Coding guidelines:

- The module initial is based on the first letter of the module's filename (instead of just saying `M`)
- use the template at <https://github.com/ellisonleao/nvim-plugin-template>
- use curl or wget to download contributor libraries from CDNs
- Ensure that the terminal for previewing logs toggles into view when a server is started. Make the option customizable from the config
- Don't use NPM
- The core modules and types used for the bare template should be updated by a workflow whenever a new p5 release is created
- The user should be able to perform multi select when selecting contributor libraries.
- Their should be a command to update installed contributor libs
- Create a minimalist json file that gets updated when new libs are installed or removed and can also be used by the plugin to setup a workspace on another machine by installing the listed libraries
- Use snacks.nvim for the components and use syntax for nvim v0.11.0 and upwards
- Look at projects that have used used WebSockets to sync browser logs to the terminal
- Keep the code DRY and instead of 'success' prefer 'ok', prefer short variable names
