
import Foundation
import SQLite3

class DBManager {
    
    static let databaseInstance = DBManager()
    
    var db : OpaquePointer?
    let dbPath :  String?
    
    private init(){
        let fileURL : URL? = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Movies.sqlite")
        dbPath = fileURL?.path
        db = openDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        guard let part1DbPath = dbPath else {
            print("dbPath is nil.")
            return nil
        }
        if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(part1DbPath)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    
    
    let createTableString = """
    create table if not exists movies(
    title char(255) primary key,
    year int,
    rating char(50),
    image char(255))
    """
    func createTable() {
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nMovies table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    let insertStatementString = "insert into movies(title, year, rating,image) values (?,?,?,?);"
    
    func insertMovie(movie : Movie) {
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            
            let title: NSString = NSString(string: movie.title ?? "" )
            let year :Int32 = Int32(movie.releaseYear ?? 0)
            let rating :NSString = NSString(format: "%.1f" , movie.rating ?? 0.0)
            let image :NSString = NSString(string: movie.image ?? "")
            
            
            sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, year)
            sqlite3_bind_text(insertStatement, 3, rating.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, image.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    
    let queryStatementString = "SELECT * FROM movies;"
    
    func queryAllMovies() -> [Movie] {
        var movies = [Movie]()
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let movie = Movie()
                
                guard let nameColumn = sqlite3_column_text(queryStatement, 0) else {
                    return movies
                }
                movie.title = String(cString: nameColumn)
                
                
                movie.releaseYear = Int(sqlite3_column_int(queryStatement, 1))
                
                guard let ratingColumn = sqlite3_column_text(queryStatement, 2) else {
                    return movies
                }
                movie.rating = Float(String(cString: ratingColumn))
                
                guard let imageColumn = sqlite3_column_text(queryStatement, 3) else {
                    return movies
                }
                movie.image = String(cString: imageColumn)
                
                movies.append(movie)
            }
            return movies
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return movies
    }
    
    
    let deleteStatementString = "DELETE FROM movies WHERE title = ?;"
    
    func deleteMovie(movie : Movie) {
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            let name :NSString = NSString(string: movie.title ?? "")
            
            sqlite3_bind_text(deleteStatement, 1, name.utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func closeDatabase(){
        sqlite3_close(db)
        print("Database closed")
    }
    
    
}
