import { useState } from "react";

const products = [
  { id: 1, name: "Katzentasse", price: 12.99, image: "/images/tasse.jpg" },
  { id: 2, name: "Plüschkatze", price: 19.99, image: "/images/plueschkatze.jpg" },
  { id: 3, name: "Katzenposter", price: 9.99, image: "/images/poster.jpg" },
  { id: 4, name: "Katzenshirt", price: 24.99, image: "/images/shirt.jpg" },
  { id: 5, name: "Notizbuch mit Katzenmotiv", price: 8.99, image: "/images/notizbuch.jpg" },
  { id: 6, name: "Katzenkalender", price: 14.99, image: "/images/kalender.jpg" },
  { id: 7, name: "Katzenohrringe", price: 6.99, image: "/images/ohrringe.jpg" },
  { id: 8, name: "Katzendecke", price: 29.99, image: "/images/decke.jpg" },
  { id: 9, name: "Katzenschlüsselanhänger", price: 5.99, image: "/images/schluesselanhaenger.jpg" },
  { id: 10, name: "Katzenposter (groß)", price: 14.99, image: "/images/poster-gross.jpg" },
  { id: 11, name: "Katzensocken", price: 9.99, image: "/images/socken.jpg" },
  { id: 12, name: "Katzenmütze", price: 19.99, image: "/images/muetze.jpg" }
];

function Shop() {
  const [cart, setCart] = useState([]);

  const addToCart = (product) => {
    setCart([...cart, product]);
  };

  return (
    <div className="container mx-auto p-8 text-center">
      <h1 className="text-3xl font-bold mb-6">Online-Shop</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {products.map((product) => (
          <div key={product.id} className="bg-white rounded-lg shadow-md p-4">
            <img src={product.image} alt={product.name} className="w-full h-40 object-cover rounded-md mb-4" />
            <h2 className="text-xl font-semibold">{product.name}</h2>
            <p className="text-gray-700">Preis: {product.price.toFixed(2)} €</p>
            <button
              onClick={() => addToCart(product)}
              className="mt-4 bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700"
            >
              In den Warenkorb
            </button>
          </div>
        ))}
      </div>
      <h2 className="text-2xl font-bold mt-8">Warenkorb</h2>
      <ul>
        {cart.map((item, index) => (
          <li key={index} className="text-lg">{item.name} - {item.price.toFixed(2)} €</li>
        ))}
      </ul>
    </div>
  );
}

export default Shop;
