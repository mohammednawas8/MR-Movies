//
//  Paginator.swift
//  MR Movies
//
//  Created by mac on 30/01/2024.
//

import Foundation

class Paginator <T> {
    
    private var initialPage: Int
    private var currentPage: Int

    private var endPaging = false
    
    private var requestItems: (_ page: Int) async throws -> [T]
    private var onLoadingStatusChange: ((_ isLoading: Bool) -> Void)?
    private var onItemsFetched: ([T]) -> Void
    private var onPaginationEnd: (() -> Void)?
    private var onError: (Error) -> Void
    
    init(
        initialPage: Int = 1,
        requestItems: @escaping (_: Int) async throws -> [T],
        loadingStatusChange: ((_: Bool) -> Void)? = nil,
        onItemsFetched: @escaping ([T]) -> Void,
        onPaginationEnd: (() -> Void)? = nil,
        onError: @escaping (Error) -> Void
    )
    {
        self.initialPage = initialPage
        self.currentPage = initialPage
        self.requestItems = requestItems
        self.onLoadingStatusChange = loadingStatusChange
        self.onItemsFetched = onItemsFetched
        self.onPaginationEnd = onPaginationEnd
        self.onError = onError
    }
    
    func loadNextItems() {
        guard endPaging == false else { return }
        Task {
            onLoadingStatusChange?(true)
            do {
                let items = try await requestItems(currentPage)
                if items.isEmpty {
                    endPaging = true
                    onPaginationEnd?()
                } else {
                    onItemsFetched(items)
                    currentPage += 1
                    onLoadingStatusChange?(false)
                }
            } catch {
                onError(error)
                onLoadingStatusChange?(false)
            }
        }
    }
    
    func reset() {
        currentPage = initialPage
    }
}


