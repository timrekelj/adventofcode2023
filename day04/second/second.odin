package second

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:time"

Card :: struct {
    id: int,
    value: int,
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    sum: int = 0

    cards := [dynamic]Card{}

    content := string(data)
    lines := strings.split_lines(content)
    for line in lines {
        if line == "" { continue }
        card_id, sum_win := parse_card(line)
        fmt.println(line)
        fmt.println(" > Card", card_id, "won", sum_win)
        append(&cards, Card{card_id, sum_win})
    }

    n_cards := len(cards)
    for i in 0..<len(cards) {
        // fmt.println("Card", cards[i].id, "won", cards[i].value)
        fmt.println("remaining: ", len(cards) - i)
        for j in 0..<cards[i].value {
            // fmt.println("Appending", cards[cards[i].id + j].id)
            append(&cards, cards[cards[i].id + j])
        }
    }

    fmt.println("Sum of cards:", len(cards))
}

parse_card :: proc(line: string) -> (int, int) {
    line, ok_replace := strings.replace_all(line, "  ", " ")
    card := strings.split(line, ": ")
    card_data := strings.split(card[0], " ")
    card_id, ok_id := strconv.parse_int(card_data[len(card_data)-1])

    sum_win := 0

    numbers := strings.split(card[1], " | ")
    picked := strings.split(numbers[1], " ")
    winning := strings.split(numbers[0], " ")

    for i in 0..<len(picked) {
        for j in 0..<len(winning) {
            if picked[i] == winning[j] {
                res, ok := strconv.parse_int(picked[i])
                sum_win += 1
            }
        }
    }
    return card_id, sum_win
}
