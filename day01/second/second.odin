package second

import "core:fmt"
import "core:os"
import "core:strings"

Numbers :: struct {
    name: string,
    value: int,
}

Result :: struct {
    index: int,
    value: int
}

numbers := [9]Numbers{
    {name = "one", value = 1},
    {name = "two", value = 2},
    {name = "three", value = 3},
    {name = "four", value = 4},
    {name = "five", value = 5},
    {name = "six", value = 6},
    {name = "seven", value = 7},
    {name = "eight", value = 8},
    {name = "nine", value = 9},
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok { panic("Failed to read file") }
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

    // Get first and last string number
    for number in numbers {
        i := strings.index(line, number.name)
        if i < first.index && i >= 0 {
            first = {
                index = i,
                value = number.value,
            }
        } 

        j := strings.last_index(line, number.name)
        if j > last.index && i >= 0 {
            last = {
                index = j,
                value = number.value,
            }
        } 
    }

    return 10 * first.value + last.value
}
