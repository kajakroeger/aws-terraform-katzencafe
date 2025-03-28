function Home() {
    return (
      <div className="container mx-auto p-8 text-center">
        <h1 className="text-4xl font-bold mb-4">Willkommen in der Samtpfoten Lounge</h1>
        <p className="text-lg text-gray-700 mb-6">
          Genieße entspannte Stunden mit unseren Katzen, während du einen köstlichen Kaffee trinkst.
        </p>
        <img
          src="/images/cafe-welcome.jpg"
          alt="Gemütliches Katzencafé"
          className="w-full max-w-2xl mx-auto rounded-lg shadow-lg"
        />
      </div>
    );
  }
  
  export default Home;
  