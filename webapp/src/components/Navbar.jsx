import { Link } from "react-router-dom";

function Navbar() {
  return (
    <nav className="bg-blue-600 text-white p-4 shadow-md">
      <div className="container mx-auto flex justify-between items-center">
        <Link to="/" className="text-lg font-bold">Samtpfoten Lounge</Link>
        <div className="space-x-4">
          <Link to="/katzen" className="hover:underline">Unsere Katzen</Link>
          <Link to="/reservierung" className="hover:underline">Reservierung</Link>
          <Link to="/shop" className="hover:underline">Shop</Link>
          <Link to="/kontakt" className="hover:underline">Kontakt</Link>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
