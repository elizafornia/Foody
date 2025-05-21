//
//  extension.swift
//  Makanan
//
//  Created by Eliza Vornia on 12/05/25.
//

import Foundation

extension Notification.Name {
    /// Notifikasi ketika user menambahkan menu ke favorit
  // static let didAddFavorite = Notification.Name("didAddFavorite")

    /// Notifikasi ketika user menghapus menu dari favorit (opsional)
    static let didRemoveFavorite = Notification.Name("didRemoveFavorite")
}
