const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const cors = require('cors');
const app = express();
const port = 3000;
app.use(cors());


app.get('/compare/:search', async (req, res) => {
    try {
      const searchTerm = req.params.search;
  
      // Amazon
      const amazonSearchUrl = `https://www.amazon.com/s?k=${encodeURIComponent(searchTerm)}`;
      const amazonResponse = await axios.get(amazonSearchUrl, { headers: { 'User-Agent': getRandomUserAgent() } });
      const $amazon = cheerio.load(amazonResponse.data);
  
      const amazonProducts = [];
      $amazon('div[data-asin]').each((index, element) => {
        const title = $amazon(element).find('span.a-text-normal').text();
        const priceInDollars = $amazon(element).find('span.a-offscreen').text();
        const imageUrl = $amazon(element).find('img.s-image').attr('src');
        amazonProducts.push({ title, price: priceInDollars, imageUrl, source: 'amazon' });
      });
  
      // Flipkart
      const flipkartSearchUrl = `https://www.flipkart.com/search?q=${encodeURIComponent(searchTerm)}`;
      const flipkartResponse = await axios.get(flipkartSearchUrl, { headers: { 'User-Agent': getRandomUserAgent() } });
      const $flipkart = cheerio.load(flipkartResponse.data);
  
      const flipkartProducts = [];
      $flipkart('div._1AtVbE').each((index, element) => {
        const title = $flipkart(element).find('div._4rR01T').text().trim();
        const price = $flipkart(element).find('div._30jeq3').text();
        const imageUrl = $flipkart(element).find('img._396cs4').attr('src');
        flipkartProducts.push({ title, price, imageUrl, source: 'flipkart' });
      });
  
      res.json({ products: [...amazonProducts, ...flipkartProducts] });
    } catch (error) {
      console.error('Error comparing search results:', error);
      res.status(500).json({ error: 'Error comparing search results' });
    }
  });
  
  

  const exchangeRate = 74.50; 

const getRandomUserAgent = () => {
  const userAgents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.59 Safari/537.36',
  ];

  const randomIndex = Math.floor(Math.random() * userAgents.length);
  return userAgents[randomIndex];
};

app.get('/search-amazon-clothing', async (req, res) => {
  try {
    const searchTerm = req.query.q;
    const amazonClothingUrl = `https://www.amazon.com/s?k=${encodeURIComponent(searchTerm)}&i=fashion`;

    const headers = {
      'User-Agent': getRandomUserAgent(),
    };

    const response = await axios.get(amazonClothingUrl, { headers });
    const $ = cheerio.load(response.data);

    const products = [];

    $('div[data-asin]').each((index, element) => {
      const title = $(element).find('span.a-text-normal').text();
      const priceInDollars = $(element).find('span.a-offscreen').text(); 
      const priceInINR = (parseFloat(priceInDollars.replace(/[^\d.]/g, '')) * exchangeRate).toFixed(2);
      const imageUrl = $(element).find('img.s-image').attr('src');

      products.push({ title, price: `₹${priceInINR}`, imageUrl });
    });

    res.json({ products });
  } catch (error) {
    console.error('Error scraping Amazon clothing:', error);
    res.status(500).json({ error: 'Error scraping Amazon clothing search results' });
  }
});
  



  
  app.get('/search-amazon', async (req, res) => {
    try {
      const searchTerm = req.query.q;
      const amazonSearchUrl = `https://www.amazon.com/s?k=${encodeURIComponent(searchTerm)}`;
  
      const headers = {
        'User-Agent': getRandomUserAgent(),
      };
  
      const response = await axios.get(amazonSearchUrl, { headers });
      const $ = cheerio.load(response.data);
  
      const products = [];
  
      $('div[data-asin]').each((index, element) => {
        const title = $(element).find('span.a-text-normal').text();
        const priceInDollars = $(element).find('span.a-offscreen').text(); 
        const imageUrl = $(element).find('img.s-image').attr('src');
  
        products.push({ title, price: priceInDollars, imageUrl });
      });
  
      res.json({ products });
    } catch (error) {
      console.error('Error scraping Amazon:', error);
      res.status(500).json({ error: 'Error scraping Amazon search results' });
    }
  });

  app.get('/search-flipkart', async (req, res) => {
    try {
      const searchTerm = req.query.q;
      const flipkartSearchUrl = `https://www.flipkart.com/search?q=${encodeURIComponent(searchTerm)}`;
  
      const headers = {
        'User-Agent': getRandomUserAgent(),
      };
  
      const response = await axios.get(flipkartSearchUrl, { headers });
      const $ = cheerio.load(response.data);
  
      const products = [];
  
      $('div._1AtVbE').each((index, element) => {
        const title = $(element).find('div._4rR01T').text().trim(); // Updated selector
        const price = $(element).find('div._30jeq3').text();
        const imageUrl = $(element).find('img._396cs4').attr('src');
  
        products.push({ title, price, imageUrl });
      });
  
      res.json({ products });
    } catch (error) {
      console.error('Error scraping Flipkart:', error);
      res.status(500).json({ error: 'Error scraping Flipkart search results' });
    }
  });
  

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
