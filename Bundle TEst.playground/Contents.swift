import UIKit

let jsonData = """
{
    "title": "The Catcher in the Rye",
    "author": "J.D. Salinger",
    "publicationYear": 1951,
    "genres": ["Fiction", "Coming-of-Age"]
}
""";

struct Book: Codable {
    let title: String
    let author: String
    let publicationYear: Int
    let genres: [String]
}

let json = jsonData.data(using: .utf8)!

do {
    let book = try JSONDecoder().decode(Book.self, from: json)
    print("Title: \(book.title)")
    print("Author: \(book.author)")
    print("Publication Year: \(book.publicationYear)")
    print("Genres: \(book.genres.joined(separator: ", "))")
} catch {
    print("Error decoding JSON: \(error.localizedDescription)")
}
