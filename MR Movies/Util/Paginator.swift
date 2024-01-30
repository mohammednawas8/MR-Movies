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
        if endPaging {
            return
        }
        Task {
            changeLoadingStatus(isLoading: true)
            do {
                let items = try await requestItems(currentPage)
                if items.isEmpty {
                    endPaging = true
                    if let onPaginationEnd {
                        onPaginationEnd()
                    }
                    return
                }
                onItemsFetched(items)
                currentPage += 1
                changeLoadingStatus(isLoading: false)
            } catch {
                onError(error)
                changeLoadingStatus(isLoading: false)
            }
        }
    }
    
    private func changeLoadingStatus(isLoading: Bool) {
        if let onLoadingStatusChange {
            onLoadingStatusChange(isLoading)
        }
    }
    
    func reset() {
        currentPage = initialPage
    }
}


