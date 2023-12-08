package second

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Type :: enum {
    HIGH_CARD,
    PAIR,
    TWO_PAIR,
    THREE_OF_A_KIND,
    FULL_HOUSE,
    FOUR_OF_A_KIND,
    FIVE_OF_A_KIND,
}

Card :: enum {
    JOKER, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN,
    QUEEN, KING, ACE
}

Hand :: struct {
    cards: [5]Card,
    type: Type,
    rank: int,
    bid: int,
    next_hand: Maybe(^Hand)
}

main :: proc() {
    data, ok := os.read_entire_file("main.input")
    if !ok {
        panic("Failed to read file")
    }
    defer delete(data)

    content := string(data)
    lines := strings.split_lines(content)

    first_hand: ^Hand

    type_counter := make(map[Card]int)
    for line, i in lines {
        hand := new(Hand)

        // Get cards
        for card, j in strings.split(line, " ")[0] {
            switch card {
                case 'J': hand.cards[j] =.JOKER
                case '2': hand.cards[j] =.TWO
                case '3': hand.cards[j] =.THREE
                case '4': hand.cards[j] =.FOUR
                case '5': hand.cards[j] =.FIVE
                case '6': hand.cards[j] =.SIX
                case '7': hand.cards[j] =.SEVEN
                case '8': hand.cards[j] =.EIGHT
                case '9': hand.cards[j] =.NINE
                case 'T': hand.cards[j] =.TEN
                case 'Q': hand.cards[j] =.QUEEN
                case 'K': hand.cards[j] =.KING
                case 'A': hand.cards[j] =.ACE
            }
            type_counter[hand.cards[j]] += 1
        }

        // Get type
        hand.type = get_hand_type(&type_counter)
        clear(&type_counter)

        // Get bid
        hand.bid = strconv.atoi(strings.split(line, " ")[1])

        // If there is no first hand
        if first_hand == nil {
            first_hand = hand
            continue
        }

        // If hand is better than first hand
        if compare_cards(hand, first_hand) {
            hand.next_hand = first_hand
            first_hand = hand
            continue
        }

        curr_hand := first_hand
        for true {
            // if reached end, append to end
            if curr_hand.next_hand == nil {
                curr_hand.next_hand = hand
                break
            }

            // compare hand and curr_hand.next_hand
            if compare_cards(hand, curr_hand.next_hand.?) {
                hand.next_hand = curr_hand.next_hand
                curr_hand.next_hand = hand
                break
            }

            // get to next hand
            curr_hand = curr_hand.next_hand.?
        }
    }

    curr_hand := first_hand
    sum := curr_hand.bid
    i := 2
    for curr_hand.next_hand != nil {
        sum += i * curr_hand.next_hand.?.bid
        curr_hand = curr_hand.next_hand.?
        i += 1
    }

    fmt.println("Total winnings are:", sum)
}

get_hand_type :: proc(type_counter: ^map[Card]int) -> Type {
    current_type: Type = .HIGH_CARD
    joker := 0
    for card, count in type_counter {
        if count == 5 {
            return .FIVE_OF_A_KIND
        } else if (card == .JOKER) {
            joker = count
            continue
        } else if count == 4 {
            current_type = .FOUR_OF_A_KIND
        } else if count == 3 {
            if (current_type ==.HIGH_CARD) {
                current_type = .THREE_OF_A_KIND
            } else if (current_type == .PAIR) {
                return .FULL_HOUSE
            }
        } else if count == 2 {
            if (current_type ==.HIGH_CARD) {
                current_type = .PAIR
            } else if (current_type ==.PAIR) {
                current_type = .TWO_PAIR
            } else if (current_type ==.THREE_OF_A_KIND) {
                return .FULL_HOUSE
            }
        }
    }

    #partial switch current_type {
        case .HIGH_CARD:
            switch joker {
                case 1: return .PAIR
                case 2: return .THREE_OF_A_KIND
                case 3: return .FOUR_OF_A_KIND
                case 4: return .FIVE_OF_A_KIND
            }
        case .TWO_PAIR:
            switch joker {
                case 1: return .FULL_HOUSE
            }
        case .PAIR:
            switch joker {
                case 1: return .THREE_OF_A_KIND
                case 2: return .FOUR_OF_A_KIND
                case 3: return .FIVE_OF_A_KIND
            }
        case .THREE_OF_A_KIND:
            switch joker {
                case 1: return .FOUR_OF_A_KIND
                case 2: return .FIVE_OF_A_KIND
            }
        case .FOUR_OF_A_KIND:
            switch joker {
                case 1: return .FIVE_OF_A_KIND
            }
    }
    return current_type
}

// Returns true if first dans has better cards than second
compare_cards :: proc(first: ^Hand, second: ^Hand) -> bool {
    if first.type < second.type {
        return true
    }
    if first.type > second.type {
        return false
    }
    for i in 0..<5 {
        if first.cards[i] < second.cards[i] {
            return true
        }
        if first.cards[i] > second.cards[i] {
            return false
        }
    }
    return false
}