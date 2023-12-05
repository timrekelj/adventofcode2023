package second

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

    content := string(data)
    lines := strings.split_lines(content)

    seeds := [dynamic][2]int{}
    for i := 0; i < len(strings.split(strings.split(lines[0], ": ")[1], " ")); i += 2 {
        append(&seeds, [2]int{
            strconv.atoi(strings.split(strings.split(lines[0], ": ")[1], " ")[i]),
            strconv.atoi(strings.split(strings.split(lines[0], ": ")[1], " ")[i]) + strconv.atoi(strings.split(strings.split(lines[0], ": ")[1], " ")[i + 1]) - 1,
        })
    }

    conversions := [dynamic][3]int{}
    new_seeds := [dynamic][2]int{}
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

        for j := 0; j < len(seeds); j += 1 {
            for conversion in conversions {
                if ( // Seed is fully in conversion
                    seeds[j][0] > conversion[1] && seeds[j][0] < (conversion[1] + conversion[2]) &&
                    seeds[j][1] > conversion[1] && seeds[j][1] < (conversion[1] + conversion[2])
                ){
                    append(&new_seeds, [2]int{
                        conversion[0] + (seeds[j][0] - conversion[1]),
                        conversion[0] + (seeds[j][1] - conversion[1]),
                    })
                    ordered_remove(&seeds, j)
                    j -= 1
                    break;
                } else if ( // Start of seed is in conversion, but end is not
                    seeds[j][0] > conversion[1] && seeds[j][0] < (conversion[1] + conversion[2])
                ){
                    for k := seeds[j][0]; k < seeds[j][1]; k += 1 {
                        if k == conversion[1] + conversion[2] {
                            append(&new_seeds, [2]int{
                                conversion[0] + (seeds[j][0] - conversion[1]),
                                conversion[0] + (k - conversion[1]),
                            })
                            append(&seeds, [2]int{
                                k,
                                seeds[j][len(seeds[j]) - 1],
                            })
                            ordered_remove(&seeds, j)
                            j -= 1
                            break;
                        }
                    }
                    break;
                } else if ( // End of seed is in conversion, but start is not
                    seeds[j][1] > conversion[1] && seeds[j][1] < (conversion[1] + conversion[2])
                ){
                    for k := seeds[j][0]; k < seeds[j][1]; k += 1 {
                        if k == conversion[1] {
                            append(&new_seeds, [2]int{
                                conversion[0] + (k - conversion[1]),
                                conversion[0] + (seeds[j][len(seeds[j]) - 1] - conversion[1]),
                            })
                            append(&seeds, [2]int{
                                seeds[j][0],
                                k,
                            })
                            ordered_remove(&seeds, j)
                            j -= 1
                            break;
                        }
                    }
                    break;
                } else if ( // Seed is around conversion
                    seeds[j][0] < conversion[1] && seeds[j][1] > (conversion[1] + conversion[2])
                ){
                    for k := seeds[j][0]; k < seeds[j][1]; k += 1 {
                        if k == conversion[1] + conversion[2] {
                            append(&seeds, [2]int{
                                seeds[j][0],
                                k
                            })
                            for h := k; h < seeds[j][1]; h += 1 {
                                if h == conversion[1] {
                                    append(&new_seeds, [2]int{
                                        conversion[0] + (k - conversion[1]),
                                        conversion[0] + (h - conversion[1]),
                                    })
                                    append(&seeds, [2]int{
                                        h,
                                        seeds[j][len(seeds[j]) - 1],
                                    })
                                    ordered_remove(&seeds, j)
                                    j -= 1
                                    break;
                                }
                            }
                            ordered_remove(&seeds, j)
                            j -= 1
                            break;
                        }
                    }
                    break;
                }
            }
        }
        for seed in new_seeds {
            append(&seeds, seed)
        }
        clear(&new_seeds)
        clear(&conversions)
    }
    min_location := seeds[0][0]
    for seed, j in seeds {
        if seed[0] < min_location {
            min_location = seed[0]
        }
    }
    fmt.println("Lowest location number: ", min_location)
}
