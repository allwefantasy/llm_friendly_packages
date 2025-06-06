# MoonBit 工具链文档合集


## 文件：index.md

---

# Toolchains

Here are some manuals that may help you use the toolchains of the programming language:

- [MoonBit's Build System](./moon/index.md): full manual of `moon` build system.
- VSCode extension
- ...

```{only} html
[Download this section in Markdown](path:/download/toolchain/summary.md)
```

```{toctree}
:maxdepth: 2
:caption: Contents:
moon/index


---


## 文件：moon/commands.md

---

# Command-Line Help for `moon`

This document contains the help content for the `moon` command-line program.

**Command Overview:**

* [`moon`↴](#moon)
* [`moon new`↴](#moon-new)
* [`moon build`↴](#moon-build)
* [`moon check`↴](#moon-check)
* [`moon run`↴](#moon-run)
* [`moon test`↴](#moon-test)
* [`moon clean`↴](#moon-clean)
* [`moon fmt`↴](#moon-fmt)
* [`moon doc`↴](#moon-doc)
* [`moon info`↴](#moon-info)
* [`moon bench`↴](#moon-bench)
* [`moon add`↴](#moon-add)
* [`moon remove`↴](#moon-remove)
* [`moon install`↴](#moon-install)
* [`moon tree`↴](#moon-tree)
* [`moon login`↴](#moon-login)
* [`moon register`↴](#moon-register)
* [`moon publish`↴](#moon-publish)
* [`moon package`↴](#moon-package)
* [`moon update`↴](#moon-update)
* [`moon coverage`↴](#moon-coverage)
* [`moon coverage report`↴](#moon-coverage-report)
* [`moon coverage clean`↴](#moon-coverage-clean)
* [`moon generate-build-matrix`↴](#moon-generate-build-matrix)
* [`moon upgrade`↴](#moon-upgrade)
* [`moon shell-completion`↴](#moon-shell-completion)
* [`moon version`↴](#moon-version)

## `moon`

**Usage:** `moon <COMMAND>`

**Subcommands:**

* `new` — Create a new MoonBit module
* `build` — Build the current package
* `check` — Check the current package, but don't build object files
* `run` — Run a main package
* `test` — Test the current package
* `clean` — Remove the target directory
* `fmt` — Format source code
* `doc` — Generate documentation
* `info` — Generate public interface (`.mbti`) files for all packages in the module
* `bench` — Run benchmarks in the current package
* `add` — Add a dependency
* `remove` — Remove a dependency
* `install` — Install dependencies
* `tree` — Display the dependency tree
* `login` — Log in to your account
* `register` — Register an account at mooncakes.io
* `publish` — Publish the current module
* `package` — Package the current module
* `update` — Update the package registry index
* `coverage` — Code coverage utilities
* `generate-build-matrix` — Generate build matrix for benchmarking (legacy feature)
* `upgrade` — Upgrade toolchains
* `shell-completion` — Generate shell completion for bash/elvish/fish/pwsh/zsh to stdout
* `version` — Print version information and exit



## `moon new`

Create a new MoonBit module

**Usage:** `moon new [OPTIONS] [PACKAGE_NAME]`

**Arguments:**

* `<PACKAGE_NAME>` — The name of the package

**Options:**

* `--lib` — Create a library package instead of an executable
* `--path <PATH>` — Output path of the package
* `--user <USER>` — The user name of the package
* `--name <NAME>` — The name part of the package
* `--license <LICENSE>` — The license of the package

  Default value: `Apache-2.0`
* `--no-license` — Do not set a license for the package



## `moon build`

Build the current package

**Usage:** `moon build [OPTIONS]`

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `llvm`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `-j`, `--jobs <JOBS>` — Set the max number of jobs to run in parallel
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `-w`, `--watch` — Monitor the file system and automatically build artifacts



## `moon check`

Check the current package, but don't build object files

**Usage:** `moon check [OPTIONS] [PACKAGE_PATH]`

**Arguments:**

* `<PACKAGE_PATH>` — The package(and it's deps) to check

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `llvm`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `-j`, `--jobs <JOBS>` — Set the max number of jobs to run in parallel
* `--output-json` — Output in json format
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `-w`, `--watch` — Monitor the file system and automatically check files
* `--patch-file <PATCH_FILE>` — The patch file to check, Only valid when checking specified package
* `--no-mi` — Whether to skip the mi generation, Only valid when checking specified package
* `--explain` — Whether to explain the error code with details



## `moon run`

Run a main package

**Usage:** `moon run [OPTIONS] <PACKAGE_OR_MBT_FILE> [ARGS]...`

**Arguments:**

* `<PACKAGE_OR_MBT_FILE>` — The package or .mbt file to run
* `<ARGS>` — The arguments provided to the program to be run

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `llvm`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `-j`, `--jobs <JOBS>` — Set the max number of jobs to run in parallel
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--build-only` — Only build, do not run the code



## `moon test`

Test the current package

**Usage:** `moon test [OPTIONS]`

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `llvm`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `-j`, `--jobs <JOBS>` — Set the max number of jobs to run in parallel
* `-p`, `--package <PACKAGE>` — Run test in the specified package
* `-f`, `--file <FILE>` — Run test in the specified file. Only valid when `--package` is also specified
* `-i`, `--index <INDEX>` — Run only the index-th test in the file. Only valid when `--file` is also specified
* `-u`, `--update` — Update the test snapshot
* `-l`, `--limit <LIMIT>` — Limit of expect test update passes to run, in order to avoid infinite loops

  Default value: `256`
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--build-only` — Only build, do not run the tests
* `--no-parallelize` — Run the tests in a target backend sequentially
* `--test-failure-json` — Print failure message in JSON format
* `--patch-file <PATCH_FILE>` — Path to the patch file
* `--doc` — Run doc test
* `--md` — Run test in markdown file

If the target is `native`, the `--release` option is not used, and no `stub-cc*`
options are specified in `moon.pkg.json` for any dependencies,
the fast-debugging-test feature will be enabled.
It will attempt to use `tcc -run` to execute the tests.

## `moon clean`

Remove the target directory

**Usage:** `moon clean`



## `moon fmt`

Format source code

**Usage:** `moon fmt [OPTIONS] [ARGS]...`

**Arguments:**

* `<ARGS>`

**Options:**

* `--check` — Check only and don't change the source code
* `--sort-input` — Sort input files
* `--block-style <BLOCK_STYLE>` — Add separator between each segments

  Possible values: `false`, `true`




## `moon doc`

Generate documentation

**Usage:** `moon doc [OPTIONS]`

**Options:**

* `--serve` — Start a web server to serve the documentation
* `-b`, `--bind <BIND>` — The address of the server

  Default value: `127.0.0.1`
* `-p`, `--port <PORT>` — The port of the server

  Default value: `3000`
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date



## `moon info`

Generate public interface (`.mbti`) files for all packages in the module

**Usage:** `moon info [OPTIONS]`

**Options:**

* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--no-alias` — Do not use alias to shorten package names in the output
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `llvm`, `all`

* `-p`, `--package <PACKAGE>` — only emit mbti files for the specified package



## `moon bench`

Run benchmarks in the current package

**Usage:** `moon bench [OPTIONS]`

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `llvm`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `-j`, `--jobs <JOBS>` — Set the max number of jobs to run in parallel
* `-p`, `--package <PACKAGE>` — Run test in the specified package
* `-f`, `--file <FILE>` — Run test in the specified file. Only valid when `--package` is also specified
* `-i`, `--index <INDEX>` — Run only the index-th test in the file. Only valid when `--file` is also specified
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--build-only` — Only build, do not bench
* `--no-parallelize` — Run the benchmarks in a target backend sequentially



## `moon add`

Add a dependency

**Usage:** `moon add [OPTIONS] <PACKAGE_PATH>`

**Arguments:**

* `<PACKAGE_PATH>` — The package path to add

**Options:**

* `--bin` — Whether to add the dependency as a binary



## `moon remove`

Remove a dependency

**Usage:** `moon remove <PACKAGE_PATH>`

**Arguments:**

* `<PACKAGE_PATH>` — The package path to remove



## `moon install`

Install dependencies

**Usage:** `moon install`



## `moon tree`

Display the dependency tree

**Usage:** `moon tree`



## `moon login`

Log in to your account

**Usage:** `moon login`



## `moon register`

Register an account at mooncakes.io

**Usage:** `moon register`



## `moon publish`

Publish the current module

**Usage:** `moon publish [OPTIONS]`

**Options:**

* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date



## `moon package`

Package the current module

**Usage:** `moon package [OPTIONS]`

**Options:**

* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--list`



## `moon update`

Update the package registry index

**Usage:** `moon update`



## `moon coverage`

Code coverage utilities

**Usage:** `moon coverage <COMMAND>`

**Subcommands:**

* `report` — Generate code coverage report
* `clean` — Clean up coverage artifacts



## `moon coverage report`

Generate code coverage report

**Usage:** `moon coverage report [args]... [COMMAND]`

**Arguments:**

* `<args>` — Arguments to pass to the coverage utility

**Options:**

* `-h`, `--help` — Show help for the coverage utility



## `moon coverage clean`

Clean up coverage artifacts

**Usage:** `moon coverage clean`



## `moon generate-build-matrix`

Generate build matrix for benchmarking (legacy feature)

**Usage:** `moon generate-build-matrix [OPTIONS] --output-dir <OUT_DIR>`

**Options:**

* `-n <NUMBER>` — Set all of `drow`, `dcol`, `mrow`, `mcol` to the same value
* `--drow <DIR_ROWS>` — Number of directory rows
* `--dcol <DIR_COLS>` — Number of directory columns
* `--mrow <MOD_ROWS>` — Number of module rows
* `--mcol <MOD_COLS>` — Number of module columns
* `-o`, `--output-dir <OUT_DIR>` — The output directory



## `moon upgrade`

Upgrade toolchains

**Usage:** `moon upgrade [OPTIONS]`

**Options:**

* `-f`, `--force` — Force upgrade
* `--dev` — Install the latest development version



## `moon shell-completion`

Generate shell completion for bash/elvish/fish/pwsh/zsh to stdout

**Usage:** `moon shell-completion [OPTIONS]`


Discussion:
Enable tab completion for Bash, Elvish, Fish, Zsh, or PowerShell
The script is output on `stdout`, allowing one to re-direct the
output to the file of their choosing. Where you place the file
will depend on which shell, and which operating system you are
using. Your particular configuration may also determine where
these scripts need to be placed.

The completion scripts won't update itself, so you may need to
periodically run this command to get the latest completions.
Or you may put `eval "$(moon shell-completion --shell <SHELL>)"`
in your shell's rc file to always load newest completions on startup.
Although it's considered not as efficient as having the completions
script installed.

Here are some common set ups for the three supported shells under
Unix and similar operating systems (such as GNU/Linux).

Bash:

Completion files are commonly stored in `/etc/bash_completion.d/` for
system-wide commands, but can be stored in
`~/.local/share/bash-completion/completions` for user-specific commands.
Run the command:

    $ mkdir -p ~/.local/share/bash-completion/completions
    $ moon shell-completion --shell bash >> ~/.local/share/bash-completion/completions/moon

This installs the completion script. You may have to log out and
log back in to your shell session for the changes to take effect.

Bash (macOS/Homebrew):

Homebrew stores bash completion files within the Homebrew directory.
With the `bash-completion` brew formula installed, run the command:

    $ mkdir -p $(brew --prefix)/etc/bash_completion.d
    $ moon shell-completion --shell bash > $(brew --prefix)/etc/bash_completion.d/moon.bash-completion

Fish:

Fish completion files are commonly stored in
`$HOME/.config/fish/completions`. Run the command:

    $ mkdir -p ~/.config/fish/completions
    $ moon shell-completion --shell fish > ~/.config/fish/completions/moon.fish

This installs the completion script. You may have to log out and
log back in to your shell session for the changes to take effect.

Elvish:

Elvish completions are commonly stored in a single `completers` module.
A typical module search path is `~/.config/elvish/lib`, and
running the command:

    $ moon shell-completion --shell elvish >> ~/.config/elvish/lib/completers.elv

will install the completions script. Note that use `>>` (append) 
instead of `>` (overwrite) to prevent overwriting the existing completions 
for other commands. Then prepend your rc.elv with:

    `use completers`

to load the `completers` module and enable completions.

Zsh:

ZSH completions are commonly stored in any directory listed in
your `$fpath` variable. To use these completions, you must either
add the generated script to one of those directories, or add your
own to this list.

Adding a custom directory is often the safest bet if you are
unsure of which directory to use. First create the directory; for
this example we'll create a hidden directory inside our `$HOME`
directory:

    $ mkdir ~/.zfunc

Then add the following lines to your `.zshrc` just before
`compinit`:

    fpath+=~/.zfunc

Now you can install the completions script using the following
command:

    $ moon shell-completion --shell zsh > ~/.zfunc/_moon

You must then open a new zsh session, or simply run

    $ . ~/.zshrc

for the new completions to take effect.

Custom locations:

Alternatively, you could save these files to the place of your
choosing, such as a custom directory inside your $HOME. Doing so
will require you to add the proper directives, such as `source`ing
inside your login script. Consult your shells documentation for
how to add such directives.

PowerShell:

The powershell completion scripts require PowerShell v5.0+ (which
comes with Windows 10, but can be downloaded separately for windows 7
or 8.1).

First, check if a profile has already been set

    PS C:\> Test-Path $profile

If the above command returns `False` run the following

    PS C:\> New-Item -path $profile -type file -force

Now open the file provided by `$profile` (if you used the
`New-Item` command it will be
`${env:USERPROFILE}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

Next, we either save the completions file into our profile, or
into a separate file and source it inside our profile. To save the
completions into our profile simply use

    PS C:\> moon shell-completion --shell powershell >>
    ${env:USERPROFILE}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

This discussion is taken from `rustup completions` command with some changes.


**Options:**

* `--shell <SHELL>` — The shell to generate completion for

  Default value: `<your shell>`

  Possible values: `bash`, `elvish`, `fish`, `powershell`, `zsh`




## `moon version`

Print version information and exit

**Usage:** `moon version [OPTIONS]`

**Options:**

* `--all` — Print all version information
* `--json` — Print version information in JSON format
* `--no-path` — Do not print the path



<hr/>

<small><i>
    This document was generated automatically by
    <a href="https://crates.io/crates/clap-markdown"><code>clap-markdown</code></a>.
</i></small>


---


## 文件：moon/coverage.md

---

# Measuring code coverage

We have included tooling for you to measure the code coverage of test and program runs.
The measurement is currently based on branch coverage.
In other words, it measures whether each program branch was executed,
and how many times if they were.

## Running code coverage in tests

To enable coverage instrumentation in tests,
you need to pass the `--enable-coverage` argument to `moon test`.

```
$ moon test --enable-coverage
...
Total tests: 3077, passed: 3077, failed: 0.
```

This will recompile the project
if they weren't previously compiled with coverage enabled.
The execution process will look the same,
but new coverage result files will be generated under the `target` directory.

```
$ ls target/wasm-gc/debug/test/ -w1
array
...
moonbit_coverage_1735628238436873.txt
moonbit_coverage_1735628238436883.txt
...
moonbit_coverage_1735628238514678.txt
option/
...
```

These files contain the information for the toolchain to determine
which parts of the program were executed,
and which parts weren't.

## Visualizing the coverage results

To visualize the result of coverage instrumentation,
you'll need to use the `moon coverage report` subcommand.

The subcommand can export the coverage in a number of formats,
controlled by the `-f` flag:

- Text summary: `summary`
- OCaml Bisect format: `bisect` (default)
- Coveralls JSON format: `coveralls`
- Cobertura XML format: `cobertura`
- HTML pages: `html`

### Text summary

`moon coverage report -f summary` exports the coverage data into stdout,
printing the covered points and total coverage point count for each file.

```
$ moon coverage report -f summary
array/array.mbt: 21/22
array/array_nonjs.mbt: 3/3
array/blit.mbt: 3/3
array/deprecated.mbt: 0/0
array/fixedarray.mbt: 115/115
array/fixedarray_sort.mbt: 110/116
array/fixedarray_sort_by.mbt: 58/61
array/slice.mbt: 6/6
array/sort.mbt: 70/70
array/sort_by.mbt: 56/61
...
```

### OCaml Bisect format

This is the default format to export, if `-f` is not specified.

`moon coverage report -f bisect` exports the coverage data into
a file `bisect.coverage` which can be read by [OCaml Bisect][bisect] tool.

[bisect]: https://github.com/aantron/bisect_ppx

### Coveralls JSON format

`moon coverage report -f coveralls` exports the coverage data into Coverall's JSON format.
This format is line-based, and can be read by both Coveralls and CodeCov.
You can find its specification [here](https://docs.coveralls.io/api-introduction#json-format-web-data).

```
$ moon coverage report -f coveralls
$ cat coveralls.json
{
    "source_files": [
        {
            "name": "builtin/console.mbt",
            "source_digest": "1c24532e12ac5bdf34b7618c9f38bd82",
            "coverage": [null,null,...,null,null]
        },
        {
            "name": "immut/array/array.mbt",
            "source_digest": "bcf1fb1d2f143ebf4423565d5a57e84f",
            "coverage": [null,null,null,...
```

You can directly send this coverage report to Coveralls or CodeCov using the `--send-to` argument.
The following is an example of using it in GitHub Actions:

```
moon coverage report \
    -f coveralls \
    -o codecov_report.json \
    --service-name github \
    --service-job-id "$GITHUB_RUN_NUMBER" \
    --service-pull-request "${{ github.event.number }}" \
    --send-to coveralls

env:
    COVERALLS_REPO_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

More information can be found in `moon coverage report --help`.

### Cobertura XML format

`moon coverage report -f cobertura` exports the coverage data into a format that can be read by [Cobertura](https://cobertura.github.io/cobertura/).

### HTML

`moon coverage report -f html` export the coverage data into a series of human-readable HTML files.
The default export location is the folder named `_coverage`.

The `index.html` in the folder shows a list of all source files,
as well as the coverage percentage in them:

![Index of the HTML](/imgs/coverage_html_index.png)

Clicking on each file shows the coverage detail within each file.
Each coverage point (start of branch)
is represented by a highlighted character in the source code:
Red means the point is not covered among all runs,
and green means the point is covered in at least one run.

Each line is also highlighted by the coverage information,
with the same color coding.
Additionally,
yellow lines are those which has partial coverage:
some points in the line are covered, while others aren't.

Some lines will not have any highlight.
This does not mean the line has not been executed at all,
just the line is not a start of a branch.
Such a line shares the coverage of closest covered the line before it.

![Detailed coverage data](/imgs/coverage_html_page.png)

## Skipping coverage

Adding the pragma `/// @coverage.skip` skips all coverage operations within the function.
Additionally, all deprecated functions will not be covered.


---


## 文件：moon/index.md

---

# Moon Build System

```{toctree}
:maxdepth: 2
:caption: Contents:
tutorial
package-manage-tour
commands
module
package
coverage
```


---


## 文件：moon/module.md

---

# Module Configuration

moon uses the `moon.mod.json` file to identify and describe a module. For full JSON schema, please check [moon's repository](https://github.com/moonbitlang/moon/blob/main/crates/moonbuild/template/mod.schema.json).

## Name

The `name` field is used to specify the name of the module, and it is required.

```json
{
  "name": "example"
  // ...
}
```

The module name can contain letters, numbers, `_`, `-`, and `/`.

For modules published to [mooncakes.io](https://mooncakes.io), the module name must begin with the username. For example:

```json
{
  "name": "moonbitlang/core"
  // ...
}
```

## Version

The `version` field is used to specify the version of the module.

This field is optional. For modules published to [mooncakes.io](https://mooncakes.io), the version number must follow the [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) specification.

```json
{
  "name": "example",
  "version": "0.1.0"
  // ...
}
```

## Deps

The `deps` field is used to specify the dependencies of the module.

It is automatically managed by commands like `moon add` and `moon remove`.

```json
{
  "name": "username/hello",
  "deps": {
    "moonbitlang/x": "0.4.6"
  }
}
```

## README

The `readme` field is used to specify the path to the module's README file.

## Repository

The `repository` field is used to specify the URL of the module's repository.

## License

The `license` field is used to specify the license of the module. The license type must comply with the [SPDX License List](https://spdx.org/licenses/).

```json
{
  "license": "MIT"
}
```

## Keywords

The `keywords` field is used to specify the keywords for the module.

```json
{
  "keywords": ["example", "test"]
}
```

## Description

The `description` field is used to specify the description of the module.

```json
{
  "description": "This is a description of the module."
}
```

## Source directory

The `source` field is used to specify the source directory of the module.

It must be a subdirectory of the directory where the `moon.mod.json` file is located and must be a relative path.

When creating a module using the `moon new` command, a `src` directory will be automatically generated, and the default value of the `source` field will be `src`.

```json
{
  "source": "src"
}
```

When the `source` field does not exist, or its value is `null` or an empty string `""`, it is equivalent to setting `"source": "."`. This means that the source directory is the same as the directory where the `moon.mod.json` file is located.

```json
{
  "source": null
}
{
  "source": ""
}
{
  "source": "."
}
```

## Warning List

This is used to disable specific preset compiler warning numbers.

For example, in the following configuration, `-2` disables the warning number 2 (Unused variable).

```json
{
  "warn-list": "-2"
}
```

You can use `moonc build-package -warn-help` to see the list of preset compiler warning numbers.

```
$ moonc -v
v0.1.20250318+35770a65e

$ moonc build-package -warn-help
Available warnings:
  1 Unused function.
  2 Unused variable.
  3 Unused type declaration.
  4 Unused abstract type.
  5 Unused type variable.
  6 Unused constructor.
  7 Unused field or constructor argument.
  8 Redundant modifier.
  9 Unused function declaration.
 10 Struct never constructed.
 11 Partial pattern matching.
 12 Unreachable code.
 13 Unresolved type variable.
 14 Lowercase type name.
 15 Unused mutability.
 16 Parser inconsistency.
 18 Useless loop expression.
 19 Top-level declaration is not left aligned.
 20 Invalid pragma
 21 Some arguments of constructor are omitted in pattern.
 22 Ambiguous block.
 23 Useless try expression.
 24 Useless error type.
 26 Useless catch all.
 27 Deprecated syntax.
 28 Todo
 29 Unused package.
 30 Empty package alias.
 31 Optional argument never supplied.
 32 Default value of optional argument never used.
 33 Unused import value
 35 Reserved keyword.
 36 Loop label shadows another label.
 37 Unused loop label.
 38 Useless guard.
 39 Duplicated method.
 40 Call a qualified method using regular call syntax.
 41 Closed map pattern.
 42 Invalid attribute.
 43 Unused attribute.
 44 Invalid inline-wasm.
 45 Type implements trait with regular methods.
  A all warnings
```

## Alert List

Disable user preset alerts.

```json
{
  "alert-list": "-alert_1-alert_2"
}
```

## Scripts

The `scripts` field is used to define custom scripts associated with the module.

### postadd script

The `postadd` script runs automatically after the module has been added.
When executed, the script's current working directory (cwd) is set to the
directory where the `moon.mod.json` file resides.

```json
{
  "scripts": {
    "postadd": "python3 build.py"
  }
}
```

### \[Experimental\] Pre-build config script

```{warning}
This feature is extremely experimental, and its API may change at any time.
This documentation reflects the implementation as of 2025-06-03.
```

```{important}
Using this feature may execute arbitrary code in your computer.
Please use with caution and only with trusted dependencies.
```

The pre-build config script is added in order to aid native target programming.
To use such script, add your script in your `moon.mod.json`:

```json
{
  "--moonbit-unstable-prebuild": "<path/to/build-script>"
}
```

The path is a relative path from the root of the project. The script may either
be a JavaScript script (with extension `.js`, `.cjs`, `.mjs`) executed with
`node`, or a Python script (with extension `.py`) executed with `python3` or
`python`.

#### Input

The script will be provided with a JSON with the structure of
`BuildScriptEnvironment` from standard input stream (stdin):

```ts
/** Represents the environment a build script receives */
interface BuildScriptEnvironment {
  env: Record<string, string>
  paths: Paths
}

interface BuildInfo {
  /** The target info for the build script currently being run. */
  host: TargetInfo
  /** The target info for the module being built. */
  target: TargetInfo
}

interface TargetInfo {
  /** The actual backend we're using, e.g. `wasm32`, `wasmgc`, `js`, `c`, `llvm` */
  kind: string // TargetBackend
}
```

#### Output

The script is expected to print a JSON string in its standard output stream
(stdout) with the structure of `BuildScriptOutput`:

```ts
interface BuildScriptOutput {
  /** Build variables */
  vars?: Record<string, string>
  /** Configurations to linking */
  link_configs?: LinkConfig[]
}

interface LinkConfig {
  /** The name of the package to configure */
  package: string

  /** Link flags that needs to be propagated to dependents
   *
   * Reference: `cargo::rustc-link-arg=FLAG` */
  link_flags?: string

  /** Libraries that need linking, propagated to dependents
   *
   * Reference: `cargo::rustc-link-lib=LIB` */
  link_libs?: string[]

  /** Paths that needs to be searched during linking, propagated to dependents
   *
   * Reference: `cargo::rustc-link-search=[KIND=]PATH` */
  link_search_paths?: string[]
}
```

#### Build variables

You may use the variables emitted in the `vars` fields in the native linking
arguments in `moon.pkg.json` as `${build.<var_name>}`.

For example, if your build script outputs:

```json
{ "vars": { "CC": "gcc" } }
```

and your `moon.pkg.json` is structured like:

```json
{
  "link": {
    "native": {
      "cc": "${build.CC}"
    }
  }
}
```

It will be transformed into

```json
{
  "link": {
    "native": {
      "cc": "gcc"
    }
  }
}
```


---


## 文件：moon/package-manage-tour.md

---

# MoonBit's Package Manager Tutorial

## Overview

MoonBit's build system seamlessly integrates package management and documentation generation tools, allowing users to easily fetch dependencies from mooncakes.io, access module documentation, and publish new modules.

[mooncakes.io](https://mooncakes.io/) is a centralized package management platform. Each module has a corresponding configuration file `moon.mod.json`, which is the smallest unit for publishing. Under the module's path, there can be multiple packages, each corresponding to a `moon.pkg.json` configuration file. The `.mbt` files at the same level as `moon.pkg.json` belong to this package.

Before getting started, make sure you have installed [moon](https://www.moonbitlang.com/download/).

## Setup mooncakes.io account

```{note}
If you don't want to publish, you can skip this step.
```

If you don't have an account on mooncakes.io, run `moon register` and follow the guide. If you have previously registered an account, you can use `moon login` to log in.

When you see the following message, it means you have successfully logged in:

```
API token saved to ~/.moon/credentials.json
```

## Update index

Use `moon update` to update the mooncakes.io index.

![moon update cli](/imgs/moon-update.png)

## Setup MoonBit project

Open an existing project or create a new project via `moon new`:

![moon new](/imgs/moon-new.png)

## Add dependencies

You can browse all available modules on mooncakes.io. Use `moon add` to add the dependencies you need, or manually edit the `deps` field in `moon.mod.json`.

For example, to add the latest version of the `Yoorkin/example/list` module:

![add deps](/imgs/add-deps.png)

## Import packages from module

Modify the configuration file `moon.pkg.json` and declare the packages that need to be imported in the `import` field.

For example, in the image below, the `hello/main/moon.pkg.json` file is modified to declare the import of `Yoorkin/example/list` in the `main` package. Now, you can call the functions of the third-party package in the `main` package using `@list`.

![import package](/imgs/import.png)

You can also give an alias to the imported package:

```json
{
    "is_main": true,
    "import": [
        { "path": "Yoorkin/example/list", "alias": "ls" }
    ]
}
```

Read the documentation of this module on mooncakes.io, we can use its `of_array` and `reverse` functions to implement a new function `reverse_array`.

![reverse array](/imgs/reverse-array.png)

## Remove dependencies

You can remove dependencies via `moon remove <module name>`.

## Publish your module

If you are ready to share your module, use `moon publish` to push a module to
mooncakes.io. There are some important considerations to keep in mind before publishing:

### Semantic versioning convention

MoonBit's package management follows the convention of [Semantic Versioning](https://semver.org/). Each module must define a version number in the format `MAJOR.MINOR.PATCH`. With each push, the module must increment the:

- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the `MAJOR.MINOR.PATCH` format.

moon implements the [minimal version selection](https://research.swtch.com/vgo-mvs), which automatically handles and installs dependencies based on the module's semantic versioning information. Minimal version selection assumes that each module declares its own dependency requirements and follows semantic versioning convention, aiming to make the user's dependency graph as close as possible to the author's development-time dependencies.

### Readme & metadata

Metadata in `moon.mod.json` and `README.md` will be shown in mooncakes.io.

Metadata consist of the following sections:

- `license`: license of this module, it following the [SPDX](https://spdx.dev/about/overview/) convention
- `keywords`: keywords of this module
- `repository`: URL of the package source repository
- `description`: short description to this module
- `homepage`: URL of the module homepage

### Moondoc

mooncakes.io will generate documentation for each module automatically.

The leading `///` comments of each toplevel will be recognized as documentation.
You can write markdown inside.

```moonbit
/// Get the largest element of a non-empty `Array`.
///
/// # Example
///
/// ```
/// maximum([1,2,3,4,5,6]) = 6
/// ```
///
/// # Panics
///
/// Panics if the `xs` is empty.
///
pub fn maximum[T : Compare](xs : Array[T]) -> T {
  // TODO ...
}
```

You can also use `moon doc --serve` to generate and view documentation locally.


---


## 文件：moon/package.md

---

# Package Configuration

moon uses the `moon.pkg.json` file to identify and describe a package. For full JSON schema, please check [moon's repository](https://github.com/moonbitlang/moon/blob/main/crates/moonbuild/template/pkg.schema.json).

## Name

The package name is not configurable; it is determined by the directory name of the package.

## is-main

The `is-main` field is used to specify whether a package needs to be linked into an executable file.

The output of the linking process depends on the backend. When this field is set to `true`:

- For the Wasm and `wasm-gc` backends, a standalone WebAssembly module will be generated.
- For the `js` backend, a standalone JavaScript file will be generated.

## Importing dependencies

### import

The `import` field is used to specify other packages that a package depends on.

For example, the following imports `moonbitlang/quickcheck` and `moonbitlang/x/encoding`, 
aliasing the latter to `lib` and importing the function `encode` from the latter.
User can write `@lib.encode` instead of `encode`.

```json
{
  "import": [
    "moonbitlang/quickcheck",
    { "path" : "moonbitlang/x/encoding", "alias": "lib", "value": ["encode"] }
  ]
}
```

### test-import

The `test-import` field is used to specify other packages that the black-box test package of this package depends on,
with the same format as `import`.

The `test-import-all` field is used to specify whether all public definitions from the package being tested should be imported (`true`) by default.

### wbtest-import

The `wbtest-import` field is used to specify other packages that the white-box test package of this package depends on,
with the same format as `import`.

## Conditional Compilation

The smallest unit of conditional compilation is a file.

In a conditional compilation expression, three logical operators are supported: `and`, `or`, and `not`, where the `or` operator can be omitted.

For example, `["or", "wasm", "wasm-gc"]` can be simplified to `["wasm", "wasm-gc"]`.

Conditions in the expression can be categorized into backends and optimization levels:

- **Backend conditions**: `"wasm"`, `"wasm-gc"`, and `"js"`
- **Optimization level conditions**: `"debug"` and `"release"`

Conditional expressions support nesting.

If a file is not listed in `"targets"`, it will be compiled under all conditions by default.

Example:

```json
{
  "targets": {
    "only_js.mbt": ["js"],
    "only_wasm.mbt": ["wasm"],
    "only_wasm_gc.mbt": ["wasm-gc"],
    "all_wasm.mbt": ["wasm", "wasm-gc"],
    "not_js.mbt": ["not", "js"],
    "only_debug.mbt": ["debug"],
    "js_and_release.mbt": ["and", ["js"], ["release"]],
    "js_only_test.mbt": ["js"],
    "js_or_wasm.mbt": ["js", "wasm"],
    "wasm_release_or_js_debug.mbt": ["or", ["and", "wasm", "release"], ["and", "js", "debug"]]
  }
}
```

## Link Options

By default, moon only links packages where `is-main` is set to `true`. If you need to link other packages, you can specify this with the `link` option.

The `link` option is used to specify link options, and its value can be either a boolean or an object.

- When the `link` value is `true`, it indicates that the package should be linked. The output will vary depending on the backend specified during the build.

  ```json
  {
    "link": true
  }
  ```

- When the `link` value is an object, it indicates that the package should be linked, and you can specify link options. For detailed configuration, please refer to the subpage for the corresponding backend.

### Wasm Backend Link Options

#### Common Options

- The `exports` option is used to specify the function names exported by the Wasm backend.

  For example, in the following configuration, the `hello` function from the current package is exported as the `hello` function in the Wasm module, and the `foo` function is exported as the `bar` function in the Wasm module. In the Wasm host, the `hello` and `bar` functions can be called to invoke the `hello` and `foo` functions from the current package.

  ```json
  {
    "link": {
      "wasm": {
        "exports": [
          "hello",
          "foo:bar"
        ]
      },
      "wasm-gc": {
        "exports": [
          "hello",
          "foo:bar"
        ]
      }
    }
  }
  ```

- The `import-memory` option is used to specify the linear memory imported by the Wasm module.

  For example, the following configuration specifies that the linear memory imported by the Wasm module is the `memory` variable from the `env` module.

  ```json
  {
    "link": {
      "wasm": {
        "import-memory": {
          "module": "env",
          "name": "memory"
        }
      },
      "wasm-gc": {
        "import-memory": {
          "module": "env",
          "name": "memory"
        }
      }
    }
  }
  ```

- The `export-memory-name` option is used to specify the name of the linear memory exported by the Wasm module.

  ```json
  {
    "link": {
      "wasm": {
        "export-memory-name": "memory"
      },
      "wasm-gc": {
        "export-memory-name": "memory"
      }
    }
  }
  ```

#### Wasm Linear Backend Link Options

- The `heap-start-address` option is used to specify the starting address of the linear memory that can be used when compiling to the Wasm backend.

  For example, the following configuration sets the starting address of the linear memory to 1024.

  ```json
  {
    "link": {
      "wasm": {
        "heap-start-address": 1024
      }
    }
  }
  ```

#### Wasm GC Backend Link Options

- The `use-js-string-builtin` option is used to specify whether the [JS String Builtin Proposal](https://github.com/WebAssembly/js-string-builtins/blob/main/proposals/js-string-builtins/Overview.md) should be enabled when compiling to the Wasm GC backend. 
  It will make the `String` in MoonBit equivalent to the `String` in JavaScript host runtime.

  For example, the following configuration enables the JS String Builtin.

  ```json
  {
    "link": {
      "wasm-gc": {
        "use-js-builtin-string": true
      }
    }
  }
  ```

- The `imported-string-constants` option is used to specify the imported string namespace used by the JS String Builtin Proposal, which is "_" by default.
  It should meet the configuration in the JS host runtime.

  For example, the following configuration and JS initialization configures the imported string namespace.

  ```json
  {
    "link": {
      "wasm-gc": {
        "use-js-builtin-string": true,
        "imported-string-constants": "_"
      }
    }
  }
  ```

  ```javascript
  const { instance } = await WebAssembly.instantiate(bytes, {}, { importedStringConstants: "strings" });
  ```

### JS Backend Link Options

- The `exports` option is used to specify the function names to export in the JavaScript module.

  For example, in the following configuration, the `hello` function from the current package is exported as the `hello` function in the JavaScript module. In the JavaScript host, the `hello` function can be called to invoke the `hello` function from the current package.

  ```json
  {
    "link": {
      "js": {
        "exports": [
          "hello"
        ]
      }
    }
  }
  ```

- The `format` option is used to specify the output format of the JavaScript module.

  The currently supported formats are:
  - `esm`
  - `cjs`
  - `iife`

  For example, the following configuration sets the output format of the current package to ES Module.

  ```json
  {
    "link": {
      "js": {
        "format": "esm"
      }
    }
  }
  ```

### Native Backend Link Options

- The `cc` option is used to specify the compiler for compiling the `moonc`-generated C source files.
  It can be either a full path to the compiler or a simple name that is accessible via the PATH environment variable.

  ```json
  {
    "link": {
      "native": {
        "cc": "/usr/bin/gcc13"
      }
    }
  }
  ```

- The `cc-flags` option is used to override the default flags passed to the compiler.
  For example, you can use the following flag to define a macro called MOONBIT.

  ```json
  {
    "link": {
      "native": {
        "cc-flags": "-DMOONBIT"
      }
    }
  }
  ```

- The `cc-link-flags` option is used to override the default flags passed to the linker.
  Since the linker is invoked through the compiler driver (e.g., `cc` instead of `ld`, `cl` instead of `link`),
  you should prefix specific options with `-Wl,` or `/link ` when passing them.

  The following example strips symbol information from produced binary.

  ```json
  {
    "link": {
      "native": {
        "cc-link-flags": "-s"
      }
    }
  }
  ```

- The `stub-cc` option is similar to `cc` but controls which compiler to use for compiling stubs.
  Although it can be different from `cc`, it is not recommended and should only be used for debugging purposes.
  Therefore, we strongly recommend to specify `cc` and `stub-cc` at the same time
  and make them consistent to avoid potential conflicts.

- The `stub-cc-flags` is similar to `cc-flags`. It only have effects on stubs compilation.

- The `stub-cc-link-flags` are similar but have a subtle difference. 
  Normally, stubs are compiled into object files and linked against object files generated from `moonc`-generated C source files. 
  This linking is only controlled by `cc-flags` and `cc-link-flags`, as mentioned earlier. 
  However, in specific modes, such as when the fast-debugging-test feature is enabled,
  there will be a separate linking procedure for stub objects files, where 
  `stub-cc-link-flags` will take effect.

#### Default C compiler and compiler flags for the native backend

Here is a brief summarization to [compiler_flags.rs](https://github.com/moonbitlang/moon/blob/main/crates/moonutil/src/compiler_flags.rs)

##### C Compiler

Search in PATH for the following items from top to bottom.

- cl
- gcc
- clang
- cc
- the internal tcc

For GCC-like compilers, the default compile & link command is as follows.
`[]` is used to indicate the flags may not exist in some modes.
```shell
cc -o $target -I$MOON_HOME/include -L$MOON_HOME/lib [-g] [-shared -fPIC] \
   -fwrapv -fno-strict-aliasing (-O2|-Og) [$MOON_HOME/lib/libmoonbitrun.o] \
   $sources -lm $cc_flags $cc_link_flags
```

For MSVC, the default compile & link command is as follows.
```shell
cl (/Fo|/Fe)$target -I$MOON_HOME/include [/LD] /utf-8 /wd4819 /nologo (/O2|/Od) \
   /link /LIBPATH:$MOON_HOME/lib
```

## Pre-build

The `"pre-build"` field is used to specify pre-build commands, which will be executed before build commands such as `moon check|build|test`.

`"pre-build"` is an array, where each element is an object containing `input`, `output`, and `command` fields. The `input` and `output` fields can be strings or arrays of strings, while the `command` field is a string. In the `command`, you can use any shell commands, as well as the `$input` and `$output` variables, which represent the input and output files, respectively. If these fields are arrays, they will be joined with spaces by default.

Currently, there is a built-in special command `:embed`, which converts files into MoonBit source code. The `--text` parameter is used to embed text files, and `--binary` is used for binary files. `--text` is the default and can be omitted. The `--name` parameter is used to specify the generated variable name, with `resource` being the default. The command is executed in the directory where the `moon.pkg.json` file is located.

```json
{
  "pre-build": [
    {
      "input": "a.txt",
      "output": "a.mbt",
      "command": ":embed -i $input -o $output"
    }
  ]
}
```

If the content of `a.txt` in the current package directory is:
```
hello,
world
```

After running `moon build`, the following `a.mbt` file will be generated in the directory where the `moon.pkg.json` is located:

```
let resource : String =
  #|hello,
  #|world
  #|
```

## Warning List

This is used to disable specific preset compiler warning numbers.

For example, in the following configuration, `-2` disables the warning number 2 (Unused variable).

```json
{
  "warn-list": "-2"
}
```

You can use `moonc build-package -warn-help` to see the list of preset compiler warning numbers.

```
$ moonc -v                      
v0.1.20250318+35770a65e

$ moonc build-package -warn-help
Available warnings: 
  1 Unused function.
  2 Unused variable.
  3 Unused type declaration.
  4 Unused abstract type.
  5 Unused type variable.
  6 Unused constructor.
  7 Unused field or constructor argument.
  8 Redundant modifier.
  9 Unused function declaration.
 10 Struct never constructed.
 11 Partial pattern matching.
 12 Unreachable code.
 13 Unresolved type variable.
 14 Lowercase type name.
 15 Unused mutability.
 16 Parser inconsistency.
 18 Useless loop expression.
 19 Top-level declaration is not left aligned.
 20 Invalid pragma
 21 Some arguments of constructor are omitted in pattern.
 22 Ambiguous block.
 23 Useless try expression.
 24 Useless error type.
 26 Useless catch all.
 27 Deprecated syntax.
 28 Todo
 29 Unused package.
 30 Empty package alias.
 31 Optional argument never supplied.
 32 Default value of optional argument never used.
 33 Unused import value
 35 Reserved keyword.
 36 Loop label shadows another label.
 37 Unused loop label.
 38 Useless guard.
 39 Duplicated method.
 40 Call a qualified method using regular call syntax.
 41 Closed map pattern.
 42 Invalid attribute.
 43 Unused attribute.
 44 Invalid inline-wasm.
 45 Type implements trait with regular methods.
  A all warnings
```

## Alert List

Disable user preset alerts.

```json
{
  "alert-list": "-alert_1-alert_2"
}
```

## Virtual Package

A virtual package serves as an interface of a package that can be replaced by actual implementations.

### Declarations

The `virtual` field is used to declare the current package as a virtual package.

For example, the following declares a virtual package with default implementation:

```json
{
  "virtual": {
    "has-default": true
  }
}
```

### Implementations

The `implement` field is used to declare the virtual package to be implemented by the current package.

For example, the following implements a virtual package:

```json
{
  "implement": "moonbitlang/core/abort"
}
```

### Overriding implementations

The `overrides` field is used to provide the implementations that fulfills an imported virtual package.

For example, the following overrides the default implementation of the builtin abort package with another package:

```json
{
  "overrides": ["moonbitlang/dummy_abort/abort_show_msg"]
}
```


---


## 文件：moon/tutorial.md

---

# MoonBit's Build System Tutorial

Moon is the build system for the MoonBit language, currently based on the [n2](https://github.com/evmar/n2) project. Moon supports parallel and incremental builds. Additionally, moon also supports managing and building third-party packages on [mooncakes.io](https://mooncakes.io/)

## Prerequisites

Before you begin with this tutorial, make sure you have installed the following:

1. **MoonBit CLI Tools**: Download it from the <https://www.moonbitlang.com/download/>. This command line tool is needed for creating and managing MoonBit projects.

    Use `moon help` to view the usage instructions.

    ```bash
    $ moon help
    ...
    ```

2. **MoonBit Language** plugin in Visual Studio Code: You can install it from the VS Code marketplace. This plugin provides a rich development environment for MoonBit, including functionalities like syntax highlighting, code completion, and more.

Once you have these prerequisites fulfilled, let's start by creating a new MoonBit module.

## Creating a New Module

To create a new module, enter the `moon new` command in the terminal, and you will see the module creation wizard. By using all the default values, you can create a new module named `username/hello` in the `my-project` directory.

```bash
$ moon new
Enter the path to create the project (. for current directory): my-project
Select the create mode: exec
Enter your username: username
Enter your project name: hello
Enter your license: Apache-2.0
Created my-project
```

> If you want to use all default values, you can use `moon new my-project` to create a new module named `username/hello` in the `my-project` directory.

## Understanding the Module Directory Structure

After creating the new module, your directory structure should resemble the following:

```bash
my-project
├── LICENSE
├── README.md
├── moon.mod.json
└── src
    ├── lib
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    └── main
        ├── main.mbt
        └── moon.pkg.json
```

Here's a brief explanation of the directory structure:

- `moon.mod.json` is used to identify a directory as a MoonBit module. It contains the module's metadata, such as the module name, version, etc. `source` specifies the source directory of the module. The default value is `src`.

  ```json
  {
    "name": "username/hello",
    "version": "0.1.0",
    "readme": "README.md",
    "repository": "",
    "license": "Apache-2.0",
    "keywords": [],
    "description": "",
    "source": "src"
  }
  ```

- `lib` and `main` directories: These are the packages within the module. Each package can contain multiple `.mbt` files, which are the source code files for the MoonBit language. However, regardless of how many `.mbt` files a package has, they all share a common `moon.pkg.json` file. `lib/*_test.mbt` are separate test files in the `lib` package, these files are for blackbox test, so private members of the `lib` package cannot be accessed directly.

- `moon.pkg.json` is package descriptor. It defines the properties of the package, such as whether it is the main package and the packages it imports.

  - `main/moon.pkg.json`:

    ```json
    {
      "is_main": true,
      "import": [
        "username/hello/lib"
      ]
    }
    ```

  Here, `"is_main: true"` declares that the package needs to be linked by the build system into a wasm file.

  - `lib/moon.pkg.json`:

    ```json
    {}
    ```

  This file is empty. Its purpose is simply to inform the build system that this folder is a package.

## Working with Packages

Our `username/hello` module contains two packages: `username/hello/lib` and `username/hello/main`.

The `username/hello/lib` package contains `hello.mbt` and `hello_test.mbt` files:

  `hello.mbt`

  ```moonbit
  pub fn hello() -> String {
      "Hello, world!"
  }
  ```

  `hello_test.mbt`

  ```moonbit
  test "hello" {
    if @lib.hello() != "Hello, world!" {
      fail!("@lib.hello() != \"Hello, world!\"")
    }
  }
  ```

The `username/hello/main` package contains a `main.mbt` file:

  ```moonbit
  fn main {
    println(@lib.hello())
  }
  ```

To execute the program, specify the file system's path to the `username/hello/main` package in the `moon run` command:

```bash
$ moon run ./src/main
Hello, world!
```

You can also omit `./`

```bash
$ moon run src/main
Hello, world!
```

You can test using the `moon test` command:

```bash
$ moon test
Total tests: 1, passed: 1, failed: 0.
```

## Package Importing

In the MoonBit's build system, a module's name is used to reference its internal packages.
To import the `username/hello/lib` package in `src/main/main.mbt`, you need to specify it in `src/main/moon.pkg.json`:

```json
{
  "is_main": true,
  "import": [
    "username/hello/lib"
  ]
}
```

Here, `username/hello/lib` specifies importing the `username/hello/lib` package from the `username/hello` module, so you can use `@lib.hello()` in `main/main.mbt`.

Note that the package name imported in `src/main/moon.pkg.json` is `username/hello/lib`, and `@lib` is used to refer to this package in `src/main/main.mbt`. The import here actually generates a default alias for the package name `username/hello/lib`. In the following sections, you will learn how to customize the alias for a package.

## Creating and Using a New Package

First, create a new directory named `fib` under `lib`:

```bash
mkdir src/lib/fib
```

Now, you can create new files under `src/lib/fib`:

`a.mbt`:

```moonbit
pub fn fib(n : Int) -> Int {
  match n {
    0 => 0
    1 => 1
    _ => fib(n - 1) + fib(n - 2)
  }
}
```

`b.mbt`:

```moonbit
pub fn fib2(num : Int) -> Int {
  fn aux(n, acc1, acc2) {
    match n {
      0 => acc1
      1 => acc2
      _ => aux(n - 1, acc2, acc1 + acc2)
    }
  }

  aux(num, 0, 1)
}
```

`moon.pkg.json`:

```json
{}
```

After creating these files, your directory structure should look like this:

```bash
my-project
├── LICENSE
├── README.md
├── moon.mod.json
└── src
    ├── lib
    │   ├── fib
    │   │   ├── a.mbt
    │   │   ├── b.mbt
    │   │   └── moon.pkg.json
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    └── main
        ├── main.mbt
        └── moon.pkg.json
```

In the `src/main/moon.pkg.json` file, import the `username/hello/lib/fib` package and customize its alias to `my_awesome_fibonacci`:

```json
{
  "is_main": true,
  "import": [
    "username/hello/lib",
    {
      "path": "username/hello/lib/fib",
      "alias": "my_awesome_fibonacci"
    }
  ]
}
```

This line imports the `fib` package, which is part of the `lib` package in the `hello` module. After doing this, you can use the `fib` package in `main/main.mbt`. Replace the file content of `main/main.mbt` to:

```moonbit
fn main {
  let a = @my_awesome_fibonacci.fib(10)
  let b = @my_awesome_fibonacci.fib2(11)
  println("fib(10) = \{a}, fib(11) = \{b}")

  println(@lib.hello())
}
```

To execute your program, specify the path to the `main` package:

```bash
$ moon run ./src/main
fib(10) = 55, fib(11) = 89
Hello, world!
```

## Adding Tests

Let's add some tests to verify our fib implementation. Add the following content in `src/lib/fib/a.mbt`:

`src/lib/fib/a.mbt`

```moonbit
test {
  assert_eq!(fib(1), 1)
  assert_eq!(fib(2), 1)
  assert_eq!(fib(3), 2)
  assert_eq!(fib(4), 3)
  assert_eq!(fib(5), 5)
}
```

This code tests the first five terms of the Fibonacci sequence. `test { ... }` defines an inline test block. The code inside an inline test block is executed in test mode.

Inline test blocks are discarded in non-test compilation modes (`moon build` and `moon run`), so they won't cause the generated code size to bloat.

## Stand-alone test files for blackbox tests

Besides inline tests, MoonBit also supports stand-alone test files. Source files ending in `_test.mbt` are considered test files for blackbox tests. For example, inside the `src/lib/fib` directory, create a file named `fib_test.mbt` and paste the following code:

`src/lib/fib/fib_test.mbt`

```moonbit
test {
  assert_eq!(@fib.fib(1), 1)
  assert_eq!(@fib.fib2(2), 1)
  assert_eq!(@fib.fib(3), 2)
  assert_eq!(@fib.fib2(4), 3)
  assert_eq!(@fib.fib(5), 5)
}
```

Notice that the test code uses `@fib` to refer to the `username/hello/lib/fib` package. The build system automatically creates a new package for blackbox tests by using the files that end with `_test.mbt`. This new package will import the current package automatically, allowing you to use `@lib` in the test code.

Finally, use the `moon test` command, which scans the entire project, identifies, and runs all inline tests as well as files ending with `_test.mbt`. If everything is normal, you will see:

```bash
$ moon test
Total tests: 3, passed: 3, failed: 0.
$ moon test -v
test username/hello/lib/hello_test.mbt::hello ok
test username/hello/lib/fib/a.mbt::0 ok
test username/hello/lib/fib/fib_test.mbt::0 ok
Total tests: 3, passed: 3, failed: 0.
```


---
