package main

import (
        "log"
        "os/exec"
)

var (
        c uint64 = 8 * 1024 * 1024 * 1024
)

func main() {
        a := make([]byte, c, c)
        for i := range a {
                a[i] = byte(i % 255)
        }

        log.Print(exec.Command("sleep", "1").Run())
}
