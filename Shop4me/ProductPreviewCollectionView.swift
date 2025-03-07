//
// Copyright (C) 2015 Twitter, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

final class ProductPreviewCollectionView: UICollectionView, UICollectionViewDataSource {
    fileprivate var products: [Product] = [] {
        didSet {
            self.reloadData()
        }
    }

    var collection: Collection? {
        didSet {
            if collection !== oldValue {
                self.products = []
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.dataSource = self
    }

    func configureWithCollection(_ collection: Collection) {
        self.collection = collection

       
//get products i think
            self.products = collection.products
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.bounds.height, height: self.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductPreviewCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductPreviewCollectionViewCell

        cell.configureWithProduct(self.products[indexPath.row])

        return cell
    }
}
