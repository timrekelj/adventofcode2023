package first

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

main :: proc() {
    data, ok := os.read_entire_file("test.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    content := string(data)
    lines := strings.split_lines(content)

    seeds := [dynamic]int{}
    for i := 0; i < len(strings.split(strings.split(lines[0], ": ")[1], " ")); i += 1 {
        append(&seeds, strconv.atoi(strings.split(strings.split(lines[0], ": ")[1], " ")[i]))
    }

    conversions := [dynamic][3]int{}
    for i := 2; i < len(lines); i += 1 {
        for j := i + 1; j < len(lines); j += 1 {
            if lines[j] == "" {
                i = j
                break
            }
            temp := [3]int{}
            for k := 0; k < 3; k += 1 {
                temp[k] = strconv.atoi(strings.split(lines[j], " ")[k])
            }
            append(&conversions, temp)
        }

        for seed, j in seeds {
            for temp in conversions {
                if seed >= temp[1] && seed < (temp[1] + temp[2]) {
                    seeds[j] = temp[0] + (seed - temp[1])
                    break
                }
            }
        }
        clear(&conversions)
    }
    min_location := seeds[0]
    for seed in seeds {
        if seed < min_location {
            min_location = seed
        }
    }
    fmt.println("Lowest location number:", min_location)
}
