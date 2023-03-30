
  if process.args.length > 4

    process.args => url = ..3 ; filename = ..4

    { get-file } = winjs.load-library 'WinjsWeb.dll'

    status-code = get-file url, filename, (, progress) -> process.io.stdout "\nprogress: #progress"

    process.io.stdout "\n\nstatus-code: #status-code"

