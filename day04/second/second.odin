package second

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Card :: struct {
    id: int,
    value: int,
    count: int
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    sum: int = 0

    cards := [dynamic]Card{}
    defer delete(cards)

    content := string(data)
    lines := strings.split_lines(content)
    for line in lines {
        if line == "" { continue }
        card_id, sum_win := parse_card(line)
        append(&cards, Card{card_id, sum_win, 1})
    }

    for card, i in cards {
        sum += card.count
        for j in i+1..=i+card.value {
            cards[j].count += card.count
        }
    }

    fmt.println("Sum of cards:", sum)
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
