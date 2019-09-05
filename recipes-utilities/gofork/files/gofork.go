package main

import (
        "log"
        "os/exec"
)

func main() {
        c := 365 * 1024 * 1024
        a := make([]byte, c, c)
        for i := range a {
                a[i] = byte(i % 255)
        }

        log.Print(exec.Command("sleep", "1").Run())
}
