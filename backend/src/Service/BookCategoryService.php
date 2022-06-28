<?php

namespace App\Service;

use App\Entity\BookCategory;
use App\Model\BookCategoryListItem;
use App\Model\BookCategoryListResponse;
use App\Repository\BookCategoryRepository;

class BookCategoryService
{
    public function __construct(private BookCategoryRepository $repository)
    {
    }

    public function getCategories(): BookCategoryListResponse
    {
        $categories = $this->repository->findAllSortedByTitle();
        $items = array_map(
            fn (BookCategory $bookCategory) => new BookCategoryListItem(
                $bookCategory->getId(),
                $bookCategory->getTitle(),
                $bookCategory->getSlug()
            ),
            $categories
        );

        return new BookCategoryListResponse($items);
    }
}
