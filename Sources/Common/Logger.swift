//
//  Logger.swift
//  Kitsune
//
//  Created by Daria Novodon on 29/04/2018.
//

import Foundation
import SwiftyBeaver

struct Logger {
  init() {
    let console = ConsoleDestination()
    console.format = "$M"
    SwiftyBeaver.addDestination(console)
  }

  func verbose(_ message: @autoclosure () -> Any,
               _ file: String = #file,
               _ function: String = #function,
               _ line: Int = #line) {
    SwiftyBeaver.verbose(message, file, function, line: line)
  }

  func debug(_ message: @autoclosure () -> Any,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
    SwiftyBeaver.debug(message, file, function, line: line)
  }

  func info(_ message: @autoclosure () -> Any,
            _ file: String = #file,
            _ function: String = #function,
            _ line: Int = #line) {
    SwiftyBeaver.info(message, file, function, line: line)
  }

  func warning(_ message: @autoclosure () -> Any,
               _ file: String = #file,
               _ function: String = #function,
               _ line: Int = #line) {
    SwiftyBeaver.warning(message, file, function, line: line)
  }

  func error(_ message: @autoclosure () -> Any,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
    SwiftyBeaver.error(message, file, function, line: line)
  }
}

let log = Logger()
