package second

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:time"

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

    start_time := time.now()

    content := strings.split_lines(string(data))
    nodes := make(map[string]Node)

    end_with_a: [dynamic]string

    for line in content[2:] {
        nodes[line[0:3]] = Node{
            left = line[7:10],
            right = line[12:15],
        }

        if line[2] == 'A' {
            append(&end_with_a, line[0:3])
        }
    }

    n_steps := 0
    steps := content[0]
    current_nodes := end_with_a[:]
    node_indexes := make(map[string]int)
    outside: for true {
        // if node has z at the end, add index to node_indexes
        for node in current_nodes {
            if node[2] == 'Z' && node_indexes[node] == 0 {
                node_indexes[node] = n_steps
                if len(node_indexes) == len(end_with_a) {
                    break outside
                }
            }
        }
        
        // Change current nodes
        for node, i in current_nodes {
            if steps[n_steps % len(steps)] == 'L' {
                current_nodes[i] = nodes[node].left
            } else if steps[n_steps % len(steps)] == 'R' {
                current_nodes[i] = nodes[node].right
            } else if steps[n_steps % len(steps)] == 'R' {
            }
        }
        n_steps += 1
    }
    
    factor := 0
    calculating: for true {
        factor += n_steps
        for k, v in node_indexes {
            if (factor % v) != 0 {
                continue calculating
            }
        }
        break
    }

    fmt.println("Steps to **Z:", factor)
}