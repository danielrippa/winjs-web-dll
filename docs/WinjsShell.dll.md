# WinjsShell.dll

```

  get-js-value:

    expand-var: (env-var-name: string) -> string

    exec: (executable: string, params: string, working-folder: string, priority: number, buffer-size: number, output-callback: function) -> 

      stdout: string
      stderr: string
      exit-status: number

    exec-verb: (verb: string, filename: string, parameters: string, class-name: string, working-directory: string; window-state: number, flags: number, monitor: number) -> boolean

    taskbar-icon: 

      set-progress-percentage: (percentage: number) -> void
      set-progress-state: (state: number) -> void

```
