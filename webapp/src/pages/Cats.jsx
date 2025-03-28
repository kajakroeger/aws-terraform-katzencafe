const cats = [
    { id: 1, name: "Luna", age: 3, breed: "Britisch Kurzhaar", image: "/images/luna.jpg" },
    { id: 2, name: "Milo", age: 2, breed: "Maine Coon", image: "/images/milo.jpg" },
    { id: 3, name: "Simba", age: 4, breed: "Siamkatze", image: "/images/simba.jpg" },
    { id: 4, name: "Bella", age: 5, breed: "Norwegische Waldkatze", image: "/images/bella.jpg" },
    { id: 5, name: "Charlie", age: 3, breed: "Ragdoll", image: "/images/charlie.jpg" },
    { id: 6, name: "Nala", age: 2, breed: "Bengalkatze", image: "/images/nala.jpg" },
    { id: 7, name: "Leo", age: 4, breed: "Perserkatze", image: "/images/leo.jpg" }
  ];
  
  function Cats() {
    return (
      <div className="container mx-auto p-8 text-center">
        <h1 className="text-3xl font-bold mb-6">Unsere Katzen</h1>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {cats.map((cat) => (
            <div key={cat.id} className="bg-white rounded-lg shadow-md p-4">
              <img src={cat.image} alt={cat.name} className="w-full h-40 object-cover rounded-md mb-4" />
              <h2 className="text-xl font-semibold">{cat.name}</h2>
              <p className="text-gray-700">Alter: {cat.age} Jahre</p>
              <p className="text-gray-700">Rasse: {cat.breed}</p>
            </div>
          ))}
        </div>
      </div>
    );
  }
  
  export default Cats;
  