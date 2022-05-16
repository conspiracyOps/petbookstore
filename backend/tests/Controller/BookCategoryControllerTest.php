<?php

namespace App\tests\Controller;

use App\Controller\BookCategoryController;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class BookCategoryControllerTest extends WebTestCase
{
    public function testCategories(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/b1/book/categories');
        $responseContent = $client->getResponse()->getContent();

        $this->assertResponseIsSuccessful();
        $this->assertJsonStringEqualsJsonFile(__DIR__ . '/responses/BookCategoryControllerTest_testCategories.json',
            $responseContent);
    }
}
