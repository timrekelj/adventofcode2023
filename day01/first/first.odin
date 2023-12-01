package first

import "core:fmt"
import "core:os"
import "core:strings"

Result :: struct {
    index: int,
    value: int
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    sum: int = 0

    content := string(data)
    for line in strings.split_lines_iterator(&content) {
        sum = sum + calculate_calibration_value(line)
    }

    fmt.println("Sum of calibration values:", sum)
}

calculate_calibration_value :: proc(line: string) -> int {
    first: Result = {index = len(line) - 1, value = 0}
    last: Result = {index = 0, value = 0}
    
    // Get first int number
    for i in 0..<len(line) {
        if line[i] >= 48 && line[i] <= 57 {
            first = {
                index = i,
                value = int(line[i]) - 48,
            }
            break
        }
    }

    // Get last int number
    for i := len(line)-1; i >= 0; i -= 1 {
        if line[i] >= 48 && line[i] <= 57 {
            last = {
                index = i,
                value = int(line[i]) - 48,
            }
            break
        }
    }

    return 10 * first.value + last.value
}