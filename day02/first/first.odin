package first

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Game :: struct {
    id: int,
    min_blue: int,
    min_red: int,
    min_green: int,
    compatible: bool,
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    sum: int = 0
    game: Game
    content := string(data)
    for line in strings.split_lines_iterator(&content) {
        game = new_game(line)
        sum += int(game.compatible) * game.id
    }

    fmt.println("Sum of compatible games: ", sum)
}

new_game :: proc(line: string) -> Game {
    res: Game = Game{
        id = strconv.atoi(strings.split(strings.split(line, ":")[0], " ")[1]),
        min_red = 0,
        min_green = 0,
        min_blue = 0,
    }

    n_color: int
    for colors in strings.split(strings.split(line, ": ")[1], "; ") {
        for color in strings.split(colors, ", ") {
            n_color = strconv.atoi(strings.split(color, " ")[0])
            switch strings.split(color, " ")[1] {
                case "red":
                    if res.min_red < n_color {
                        res.min_red = n_color
                    }
                case "green":
                    if res.min_green < n_color {
                        res.min_green = n_color
                    }
                case "blue":
                    if res.min_blue < n_color {
                        res.min_blue = n_color
                    }
            }
        }
    }
    
    res.compatible = res.min_red <= 12 && res.min_green <= 13 && res.min_blue <= 14
    
    return res
}
