package first

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Node :: struct {
    left: string,
    right: string
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    content := strings.split_lines(string(data))
    nodes := make(map[string]Node)

    for line in content[2:] {
        nodes[line[0:3]] = Node{
            left = line[7:10],
            right = line[12:15],
        }
    }

    n_steps := 0
    steps := content[0]
    current_node := "AAA"
    for true {
        if current_node == "ZZZ" {
            break
        }
        if steps[n_steps % len(steps)] == 'L' {
            current_node = nodes[current_node].left
            n_steps += 1
        } else if steps[n_steps % len(steps)] == 'R' {
            current_node = nodes[current_node].right
            n_steps += 1
        }
    }

    fmt.println("Steps to reach ZZZ:", n_steps)
}