---
layout: post
title: "Responsive Terminal Applications in Golang"
description: "While developing a terminal application with Golang, I recently struggled with the implementation of a feature, that was the responsiveness of the terminal application to window size changes."
date: 2021-05-08 16:41:50
author: Erhan Bagdemir
comments: true
keywords: "Golang, Terminal"
category: Programming
image:  '/images/17.jpg'
tags:
- Golang
- Programming
---
 
While developing a terminal application with Golang, I recently struggled with the implementation of a feature, that was the responsiveness of the terminal application to window size changes. The task was to re-draw my ASCII UI whenever the terminal window get resized. Fortunately, POSIX compliant operating systems send a proper signal to notify the process, that is SIGWINCH and to write a signal handler in Golang is pretty straightforward: 

```go
// ListenSIG listens to SIGWINCH syscall to react on window size changes.
func (w *Window) ListenSIG() {
  go func() {
    for {
      c := make(chan os.Signal, 1)
      signal.Notify(c, syscall.SIGWINCH)
      // Block until a signal is received.
      <-c
      w.Render()
    }
  }()
}
```
<br/>
In the example above, I create a new channel to catch the system calls within a go routine. Since the current thread gets blocked and I don't want whole application to stop while while listening to signals, I put the signal handling code into its own gorouting. By doing so, my code is able to listen to window size change signals and call Render() function of my application's window infinitely while processing other tasks. 

Another way to implement a similar feature is by polling the current terminal window size. I don't think, however, that this approach would be as efficient as the former one, if you are not able to take signal-handler-approach otherwise, 

```go
// Private types
type screenSize struct {
  Row    uint16
  Col    uint16
  Xpixel uint16
  Ypixel uint16
}

func GetScreenSize() (uint16, uint16) {
  ws := new(screenSize)
  retCode, _, errno := syscall.Syscall(syscall.SYS_IOCTL,
    uintptr(syscall.Stdin),
    uintptr(syscall.TIOCGWINSZ),
    uintptr(unsafe.Pointer(ws)))

  if int(retCode) == -1 {
    panic(errno)
  }
  return ws.Row, ws.Col
}
```
<br/>
The GetScreenSize function sends a system call to Ioctls for terminals and serial lines to find out the current screen size of the terminal, by passing the TIOCGWINSZ. The return value will be stored in an struct. This way, you can determine the current terminal window size and repeat this call, for instance, every a few seconds to capture the window size changes. 
