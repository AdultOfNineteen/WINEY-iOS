//
//  NoteManager.swift
//  Winey
//
//  Created by 정도현 on 6/7/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

final class NoteManager: ObservableObject {
  static let shared = NoteManager()

  private init() { }

  public var noteList: NoteCardScroll.State?
}
