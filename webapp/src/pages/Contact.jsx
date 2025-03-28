function Contact() {
  return (
    <div className="container mx-auto p-8 text-left">
      <h1 className="text-3xl font-bold mb-4">Kontakt</h1>
      <p>Haben Sie Fragen oder möchten eine Reservierung ändern? Kontaktieren Sie uns:</p>
      <p><strong>Adresse:</strong><br/>Samtpfoten Lounge<br/>Musterstraße 1<br/>12345 Musterstadt</p>
      <p><strong>Telefon:</strong> 01234 / 567890</p>
      <p><strong>E-Mail:</strong> info@samtpfoten-lounge.de</p>
      <h2 className="text-2xl font-semibold mt-6">Kontaktformular</h2>
      <form className="max-w-lg bg-white p-6 rounded-lg shadow-md">
        <label className="block mb-2">Ihr Name:</label>
        <input type="text" className="w-full p-2 border rounded" required />

        <label className="block mt-4 mb-2">Ihre E-Mail:</label>
        <input type="email" className="w-full p-2 border rounded" required />

        <label className="block mt-4 mb-2">Ihre Nachricht:</label>
        <textarea className="w-full p-2 border rounded" rows="4" required></textarea>

        <button type="submit" className="w-full mt-4 bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
          Nachricht senden
        </button>
      </form>
    </div>
  );
}

export default Contact;
