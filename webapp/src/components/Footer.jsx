function Footer() {
    return (
      <footer className="bg-gray-800 text-white text-center p-4 mt-8">
        <div className="container mx-auto">
          <p>&copy; {new Date().getFullYear()} Samtpfoten Lounge - Alle Rechte vorbehalten.</p>
          <div className="mt-2">
            <a href="/impressum" className="hover:underline mr-4">Impressum</a>
            <a href="/datenschutz" className="hover:underline">Datenschutz</a>
          </div>
        </div>
      </footer>
    );
  }
  
  export default Footer;
  