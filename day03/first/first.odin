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
    content := strings.split(string(data), "\n")

    n_start := 0
    n_end := 0
    for i := 0; i < len(content); i += 1 {
        for j := 0; j < len(content[i]); j += 1{
            if content[i][j] >= 48 && content[i][j] <= 57 {
                // get number 
                n_start = j
                for j < len(content[i])  && content[i][j] >= 48 && content[i][j] <= 57 {
                    j += 1
                }
                n_end = j

                if (
                    // before and after
                    (n_start != 0 && valid_string(content[i][n_start - 1:n_start])) ||
                    (n_end < len(content[i]) - 1 && valid_string(content[i][n_end:n_end + 1])) ||

                    // above and below
                    (i != 0 && valid_string(content[i - 1][n_start:n_end])) ||
                    (i < len(content) - 2 && valid_string(content[i + 1][n_start:n_end])) ||

                    // diagonal
                    (i != 0 && n_start != 0 && valid_string(content[i - 1][n_start - 1:n_start])) ||
                    (i != 0 && n_end < len(content[i]) - 1 && valid_string(content[i - 1][n_end:n_end + 1])) ||
                    (i < len(content) - 2 && n_end < len(content[i]) - 1 && valid_string(content[i + 1][n_end:n_end + 1])) ||
                    (i < len(content) - 2 && n_start != 0 && valid_string(content[i + 1][n_start - 1:n_start]))
                ) {

                    sum += strconv.atoi(content[i][n_start:n_end])
                }
            }
        }
    }
    
    fmt.println("Sum of part numbers:", sum)
}

valid_string :: proc(check: string) -> bool {
    for i := 0; i < len(check); i += 1 {
        if (check[i] < 48 || check[i] > 57) && check[i] != '.' {
            return true
        }
    }
    return false
}
