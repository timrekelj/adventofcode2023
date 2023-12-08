package second

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Gear :: struct {
    line: int,
    col: int,
    count: int,
    multiply: int
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    sum: int = 0
    content := strings.split(string(data), "\n")

    gears := [dynamic]Gear{}

    n_start := 0
    n_end := 0
    for i := 0; i < len(content); i += 1 {
        for j := 0; j < len(content[i]); j += 1{
            if content[i][j] >= 48 && content[i][j] <= 57 {
                n_start = j
                for j < len(content[i])  && content[i][j] >= 48 && content[i][j] <= 57 {
                    j += 1
                }
                n_end = j

                // before number
                if n_start != 0 && find_in_string(content[i][n_start - 1:n_start]) != -1 {
                    set_gear(&gears, n_start - 1, i, strconv.atoi(content[i][n_start:n_end]))
                }
                // after number
                if n_end < len(content[i]) - 1 && find_in_string(content[i][n_end:n_end + 1]) != -1 {
                    set_gear(&gears, n_end, i, strconv.atoi(content[i][n_start:n_end]))
                }
                // above number
                if i != 0 && find_in_string(content[i - 1][n_start:n_end]) != -1 {
                    set_gear(&gears, n_start + find_in_string(content[i - 1][n_start:n_end]), i - 1, strconv.atoi(content[i][n_start:n_end]))
                }
                // below number
                if i < len(content) - 2 && find_in_string(content[i + 1][n_start:n_end]) != -1 {
                    set_gear(&gears, n_start + find_in_string(content[i + 1][n_start:n_end]), i + 1, strconv.atoi(content[i][n_start:n_end]))
                }
                // top right of number
                if i != 0 && n_end < len(content[i]) - 1 && find_in_string(content[i - 1][n_end:n_end + 1]) != -1 {
                    set_gear(&gears, n_end, i - 1, strconv.atoi(content[i][n_start:n_end]))
                }
                // top left of number
                if i != 0 && n_start != 0 && find_in_string(content[i - 1][n_start - 1:n_start]) != -1 {
                    set_gear(&gears, n_start - 1, i - 1, strconv.atoi(content[i][n_start:n_end]))
                }
                // bottom right of number
                if i < len(content) - 2 && n_end < len(content[i]) - 1 && find_in_string(content[i + 1][n_end:n_end + 1]) != -1 {
                    set_gear(&gears, n_end, i + 1, strconv.atoi(content[i][n_start:n_end]))
                }
                // bottom left of number
                if i < len(content) - 2 && n_start != 0 && find_in_string(content[i + 1][n_start - 1:n_start]) != -1 {
                    set_gear(&gears, n_start - 1, i + 1, strconv.atoi(content[i][n_start:n_end]))
                }
            }
        }
    }

    for gear in gears {
        if gear.count > 1 {
            sum += gear.multiply
        }
    }

    fmt.println("Sum of part numbers:", sum)
}

find_in_string :: proc(check: string) -> int {
    for i := 0; i < len(check); i += 1 {
        if check[i] == '*' {
            return i
        }
    }
    return -1
}

set_gear :: proc(gears: ^[dynamic]Gear, col: int, line: int, number: int) {
    for i := 0; i < len(gears); i += 1 {
        if gears[i].col == col && gears[i].line == line {
            gears[i].count += 1
            gears[i].multiply *= number
            return
        }
    }
    append(gears, Gear{line = line, col = col, count = 1, multiply = number})
}
