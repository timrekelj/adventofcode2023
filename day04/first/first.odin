package first

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    sum: int = 0

    content := string(data)
    for line in strings.split_lines_iterator(&content) {
        sum = sum + calculate_winnings(line)
    }

    fmt.println("Sum of winnings:", sum)
}

calculate_winnings :: proc(line: string) -> int {
    line, ok := strings.replace_all(line, "  ", " ")
    card := strings.split(line, ": ")

    sum_win := 0

    numbers := strings.split(card[1], " | ")
    picked := strings.split(numbers[1], " ")
    winning := strings.split(numbers[0], " ")

    for i in 0..<len(picked) {
        for j in 0..<len(winning) {
            if picked[i] == winning[j] {
                res, ok := strconv.parse_int(picked[i])
                if sum_win == 0 {
                    sum_win = 1
                } else {
                    sum_win = sum_win * 2
                }
            }
        }
    }
    return sum_win
}
