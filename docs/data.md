# Data Module

This module contains 21 symbols from p5.js.

## append

**Type:** Function

Adds a value to the end of an array. Extends the length of the array by one. Maps to Array.push().

### Parameters

- `array`: Array - Array to append
- `value`: any - to be added to the Array

### Returns

Array - the array that was appended to

⚠️ **Deprecated:** true

---

## clearStorage

**Type:** Function

Removes all items in the web browser's local storage. Web browsers can save small amounts of data using the built-in <a href="https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage" target="_blank">localStorage object</a>. Data stored in `localStorage` can be retrieved at any point, even after refreshing a page or restarting the browser. Data are stored as key-value pairs. Calling `clearStorage()` removes all data from `localStorage`. Note: Sensitive data such as passwords or personal information shouldn't be stored in `localStorage`.

---

## concat

**Type:** Function

Concatenates two arrays, maps to Array.concat(). Does not modify the input arrays.

### Parameters

- `a`: Array - first Array to concatenate
- `b`: Array - second Array to concatenate

### Returns

Array - concatenated array

⚠️ **Deprecated:** true

---

## getItem

**Type:** Function

Returns a value in the web browser's local storage. Web browsers can save small amounts of data using the built-in <a href="https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage" target="_blank">localStorage object</a>. Data stored in `localStorage` can be retrieved at any point, even after refreshing a page or restarting the browser. Data are stored as key-value pairs. <a href="#/p5/storeItem">storeItem()</a> makes it easy to store values in `localStorage` and `getItem()` makes it easy to retrieve them. The first parameter, `key`, is the name of the value to be stored as a string. The second parameter, `value`, is the value to be retrieved a string. For example, calling `getItem('size')` retrieves the value with the key `size`. Note: Sensitive data such as passwords or personal information shouldn't be stored in `localStorage`.

### Parameters

- `key`: String - name of the value.

### Returns

String|Number|Boolean|Object|Array - stored item.

---

## join

**Type:** Function

Combines an array of strings into one string. The first parameter, `list`, is the array of strings to join. The second parameter, `separator`, is the character(s) that should be used to separate the combined strings. For example, calling `join(myWords, ' : ')` would return a string of words each separated by a colon and spaces.

### Parameters

- `list`: Array - array of strings to combine.
- `separator`: String - character(s) to place between strings when they're combined.

### Returns

String - combined string.

---

## match

**Type:** Function

Applies a regular expression to a string and returns an array with the first match. `match()` uses regular expressions (regex) to match patterns in text. For example, the regex `abc` can be used to search a string for the exact sequence of characters `abc`. See <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions#tools" target="_blank">MDN</a>. for more information about regexes. The first parameter, `str`, is the string to search. The second parameter, `regex`, is a string with the regular expression to apply. For example, calling `match('Hello, p5*js!', '[a-z][0-9]')` would return the array `['p5']`. Note: If no matches are found, `null` is returned.

### Parameters

- `str`: String - string to search.
- `regexp`: String - regular expression to match.

### Returns

String[] - match if found.

---

## matchAll

**Type:** Function

Applies a regular expression to a string and returns an array of matches. `match()` uses regular expressions (regex) to match patterns in text. For example, the regex `abc` can be used to search a string for the exact sequence of characters `abc`. See <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions#tools" target="_blank">MDN</a>. for more information about regexes. `matchAll()` is different from <a href="#/p5/match">match()</a> because it returns every match, not just the first. The first parameter, `str`, is the string to search. The second parameter, `regex`, is a string with the regular expression to apply. For example, calling `matchAll('p5*js is easier than abc123', '[a-z][0-9]')` would return the 2D array `[['p5'], ['c1']]`. Note: If no matches are found, an empty array `[]` is returned.

### Parameters

- `str`: String - string to search.
- `regexp`: String - regular expression to match.

### Returns

String[] - matches found.

---

## NumberDict

**Type:** Class

A simple Dictionary class for Numbers.

---

## removeItem

**Type:** Function

Removes an item from the web browser's local storage. Web browsers can save small amounts of data using the built-in <a href="https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage" target="_blank">localStorage object</a>. Data stored in `localStorage` can be retrieved at any point, even after refreshing a page or restarting the browser. Data are stored as key-value pairs. <a href="#/p5/storeItem">storeItem()</a> makes it easy to store values in `localStorage` and `removeItem()` makes it easy to delete them. The parameter, `key`, is the name of the value to remove as a string. For example, calling `removeItem('size')` removes the item with the key `size`. Note: Sensitive data such as passwords or personal information shouldn't be stored in `localStorage`.

### Parameters

- `key`: String - name of the value to remove.

---

## reverse

**Type:** Function

Reverses the order of an array, maps to Array.reverse()

### Parameters

- `list`: Array - Array to reverse

### Returns

Array - the reversed list

⚠️ **Deprecated:** true

---

## shorten

**Type:** Function

Decreases an array by one element and returns the shortened array, maps to Array.pop().

### Parameters

- `list`: Array - Array to shorten

### Returns

Array - shortened Array

⚠️ **Deprecated:** true

---

## shuffle

**Type:** Function

Shuffles the elements of an array. The first parameter, `array`, is the array to be shuffled. For example, calling `shuffle(myArray)` will shuffle the elements of `myArray`. By default, the original array won’t be modified. Instead, a copy will be created, shuffled, and returned. The second parameter, `modify`, is optional. If `true` is passed, as in `shuffle(myArray, true)`, then the array will be shuffled in place without making a copy.

### Parameters

- `array`: Array - array to shuffle.
- `{Boolean} [bool] if `true`, shuffle the original array in place. Defaults to `false`.`: unknown - No description

### Returns

Array - shuffled array.

---

## sort

**Type:** Function

Sorts an array of numbers from smallest to largest, or puts an array of words in alphabetical order. The original array is not modified; a re-ordered array is returned. The count parameter states the number of elements to sort. For example, if there are 12 elements in an array and count is set to 5, only the first 5 elements in the array will be sorted.

### Parameters

- `list`: Array - Array to sort
- `{Integer} [count] number of elements to sort, starting from 0`: unknown - No description

### Returns

Array - the sorted list

⚠️ **Deprecated:** true

---

## splice

**Type:** Function

Inserts a value or an array of values into an existing array. The first parameter specifies the initial array to be modified, and the second parameter defines the data to be inserted. The third parameter is an index value which specifies the array position from which to insert data. (Remember that array index numbering starts at zero, so the first position is 0, the second position is 1, and so on.)

### Parameters

- `list`: Array - Array to splice into
- `value`: any - value to be spliced in
- `position`: Integer - in the array from which to insert data

### Returns

Array - the list

⚠️ **Deprecated:** true

---

## split

**Type:** Function

Splits a `String` into pieces and returns an array containing the pieces. The first parameter, `value`, is the string to split. The second parameter, `delim`, is the character(s) that should be used to split the string. For example, calling `split('rock...paper...scissors', '...')` would return the array `['rock', 'paper', 'scissors']` because there are three periods `...` between each word.

### Parameters

- `value`: String - the String to be split
- `delim`: String - the String used to separate the data

### Returns

String[] - Array of Strings

---

## splitTokens

**Type:** Function

Splits a `String` into pieces and returns an array containing the pieces. `splitTokens()` is an enhanced version of <a href="#/p5/split">split()</a>. It can split a string when any characters from a list are detected. The first parameter, `value`, is the string to split. The second parameter, `delim`, is optional. It sets the character(s) that should be used to split the string. `delim` can be a single string, as in `splitTokens('rock...paper...scissors...shoot', '...')`, or an array of strings, as in `splitTokens('rock;paper,scissors...shoot, [';', ',', '...'])`. By default, if no `delim` characters are specified, then any whitespace character is used to split. Whitespace characters include tab (`\t`), line feed (`\n`), carriage return (`\r`), form feed (`\f`), and space.

### Parameters

- `value`: String - string to split.
- `{String} [delim] character(s) to use for splitting the string.`: unknown - No description

### Returns

String[] - separated strings.

---

## storeItem

**Type:** Function

Stores a value in the web browser's local storage. Web browsers can save small amounts of data using the built-in <a href="https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage" target="_blank">localStorage object</a>. Data stored in `localStorage` can be retrieved at any point, even after refreshing a page or restarting the browser. Data are stored as key-value pairs. `storeItem()` makes it easy to store values in `localStorage` and <a href="#/p5/getItem">getItem()</a> makes it easy to retrieve them. The first parameter, `key`, is the name of the value to be stored as a string. The second parameter, `value`, is the value to be stored. Values can have any type. Note: Sensitive data such as passwords or personal information shouldn't be stored in `localStorage`.

### Parameters

- `key`: String - name of the value.
- `value`: String|Number|Boolean|Object|Array - value to be stored.

---

## str

**Type:** Function

Converts a `Boolean` or `Number` to `String`. `str()` converts values to strings. See the <a href="#/p5/String">String</a> reference page for guidance on using template literals instead. The parameter, `n`, is the value to convert. If `n` is a Boolean, as in `str(false)` or `str(true)`, then the value will be returned as a string, as in `'false'` or `'true'`. If `n` is a number, as in `str(123)`, then its value will be returned as a string, as in `'123'`. If an array is passed, as in `str([12.34, 56.78])`, then an array of strings will be returned.

### Parameters

- `n`: String|Boolean|Number - value to convert.

### Returns

String - converted string.

---

## StringDict

**Type:** Class

A simple Dictionary class for Strings.

---

## subset

**Type:** Function

Extracts an array of elements from an existing array. The list parameter defines the array from which the elements will be copied, and the start and count parameters specify which elements to extract. If no count is given, elements will be extracted from the start to the end of the array. When specifying the start, remember that the first array element is 0. This function does not change the source array.

### Parameters

- `list`: Array - Array to extract from
- `start`: Integer - position to begin
- `{Integer} [count] number of values to extract`: unknown - No description

### Returns

Array - Array of extracted elements

⚠️ **Deprecated:** true

---

## TypedDict

**Type:** Class

Base class for all p5.Dictionary types. Specifically typed Dictionary classes inherit from this class.

---

