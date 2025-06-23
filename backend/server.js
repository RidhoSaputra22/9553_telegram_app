const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const multer = require('multer');
const path = require('path');

require('dotenv').config();

const app = express();

// Konfigurasi multer yang terpusat
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/') 
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname))
  }
});

const upload = multer({ storage: storage });

// Middleware dalam urutan yang benar
app.use(cors());
app.use(express.json());
app.use('/images', express.static('images'));
app.use('/uploads', express.static('uploads'));

// Tambahkan logging middleware
app.use((req, res, next) => {
  console.log('Incoming request:', {
    method: req.method,
    path: req.path,
    body: req.body,
    headers: req.headers
  });
  next();
});

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'telegram_clone'
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server berjalan di port ${port}`);
});

// Setelah koneksi database berhasil
db.connect((err) => {
  if (err) {
    console.error('Error koneksi ke database:', err);
    return;
  }
  console.log('Terhubung ke database MySQL');
});

// Pindahkan promiseDb ke sini
const promiseDb = db.promise();

// Konfigurasi multer yang terpusat




// Middleware untuk serving static files
app.use('/uploads', express.static('uploads'));

app.post('/api/users', (req, res) => {
  const { country_name, country_code, phone_number, profile_picture } = req.body;
  
  // Cek apakah nomor telepon sudah ada
  const checkQuery = 'SELECT * FROM users WHERE phone_number = ?';
  db.query(checkQuery, [phone_number], (err, results) => {
    if (err) {
      console.error('Error memeriksa user:', err);
      res.status(500).json({ error: 'Gagal memeriksa user' });
      return;
    }

    // Jika user sudah ada, kirim response dengan data user
    if (results.length > 0) {
      res.status(200).json({
        message: 'User ditemukan',
        isNewUser: false,
        user: results[0]
      });
      return;
    }

    // Jika user belum ada, buat user baru
    const insertQuery = 'INSERT INTO users (country_name, country_code, phone_number, profile_picture) VALUES (?, ?, ?, ?)';
    db.query(insertQuery, [country_name, country_code, phone_number, profile_picture], (err, result) => {
      if (err) {
        console.error('Error menyimpan user:', err);
        res.status(500).json({ error: 'Gagal menyimpan user' });
        return;
      }
      res.status(201).json({
        message: 'User berhasil disimpan',
        isNewUser: true,
        user: {
          id: result.insertId,
          country_name,
          country_code,
          phone_number,
          profile_picture
        }
      });
    });
  });
});

app.get('/api/chats', (req, res) => {
    db.query('SELECT id, name, message, time, unread_count, profile_picture, image_type, avatar_color, is_verified, has_photo FROM chats', (error, results) => {
        if (error) {
            console.error('Error fetching chats:', error);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }
        
        const chatsWithBase64Images = results.map(chat => ({
            id: chat.id,
            name: chat.name,
            message: chat.message,
            time: chat.time,
            unread_count: chat.unread_count,
            profile_picture: chat.profile_picture ? 
                `data:image/${chat.image_type};base64,${chat.profile_picture.toString('base64')}` : 
                null,
            avatar_color: chat.avatar_color,
            is_verified: chat.is_verified,
            has_photo: chat.has_photo
        }));
        res.json(chatsWithBase64Images);
    });
});

app.get('/api/chats/:id/image', (req, res) => {
    const chatId = req.params.id;
    db.query('SELECT profile_picture, image_type FROM chats WHERE id = ?', [chatId], (error, results) => {
        if (error || results.length === 0) {
            res.status(404).send('Image not found');
            return;
        }
        
        const image = results[0];
        if (!image.profile_picture) {
            res.status(404).send('Image not found');
            return;
        }
        
        res.setHeader('Content-Type', `image/${image.image_type}`);
        res.send(image.profile_picture);
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});

app.put('/api/users/:id/profile-picture', (req, res) => {
  const { id } = req.params;
  const { profile_picture } = req.body;

  const updateQuery = 'UPDATE users SET profile_picture = ? WHERE id = ?';
  db.query(updateQuery, [profile_picture, id], (err, result) => {
    if (err) {
      console.error('Error mengupdate foto profil:', err);
      res.status(500).json({ error: 'Gagal mengupdate foto profil' });
      return;
    }

    if (result.affectedRows === 0) {
      res.status(404).json({ error: 'User tidak ditemukan' });
      return;
    }

    res.status(200).json({
      message: 'Foto profil berhasil diupdate',
      profile_picture
    });
  });
});

// Gunakan multer yang sudah dideklarasikan sebelumnya


// Endpoint untuk mengirim pesan dengan media
app.post('/api/messages', async (req, res) => {
  try {
    const { sender_id, receiver_id, message_text, media_url } = req.body;
    
    console.log('Received message data:', { sender_id, receiver_id, message_text, media_url }); // Untuk debugging

    const query = `
      INSERT INTO messages (sender_id, receiver_id, message_text, media_url, timestamp)
      VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
    `;

    const [result] = await promiseDb.query(query, [
      sender_id,
      receiver_id,
      message_text,
      media_url
    ]);

    res.status(201).json({ 
      success: true, 
      message_id: result.insertId,
      message: 'Message sent successfully'
    });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
});

// Endpoint untuk mengambil pesan-pesan dari suatu chat
app.get('/api/chats/:chatId/messages', (req, res) => {
    const chatId = req.params.chatId;
    const query = 'SELECT * FROM messages WHERE chat_id = ? ORDER BY timestamp DESC';
    
    db.query(query, [chatId], (error, results) => {
        if (error) {
            console.error('Error fetching messages:', error);
            res.status(500).json({ error: 'Failed to fetch messages' });
            return;
        }
        
        const messages = results.map(message => ({
            id: message.id,
            chatId: message.chat_id,
            messageType: message.message_type,
            textContent: message.text_content,
            timestamp: message.timestamp,
            mediaUrl: message.content ? 
                `data:${message.media_type};base64,${message.content.toString('base64')}` : 
                null
        }));
        
        res.json(messages);
    });
});

app.get('/api/messages/:sender_id/:receiver_id', (req, res) => {
    const { sender_id, receiver_id } = req.params;
    const query = `
        SELECT * FROM messages 
        WHERE (sender_id = ? AND receiver_id = ?)
        OR (sender_id = ? AND receiver_id = ?)
        ORDER BY timestamp DESC
    `;
    
    db.query(query, [sender_id, receiver_id, receiver_id, sender_id], (error, results) => {
        if (error) {
            console.error('Error fetching messages:', error);
            res.status(500).json({ error: 'Failed to fetch messages' });
            return;
        }
        
        const messages = results.map(message => ({
            id: message.id,
            sender_id: message.sender_id,
            receiver_id: message.receiver_id,
            message_text: message.message_text,
            media_type: message.media_type,
            media_url: message.media_url,
            timestamp: message.timestamp
        }));
        
        res.json(messages);
    });

  });

// Konfigurasi penyimpanan media




// Endpoint untuk upload media
app.post('/api/messages/media', upload.single('media'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }
    
    // URL untuk mengakses file
    const mediaUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    
    res.json({
      mediaUrl: mediaUrl,
      message: 'File uploaded successfully'
    });
  } catch (error) {
    console.error('Error uploading file:', error);
    res.status(500).json({ error: 'Failed to upload file' });
  }
});

// Serve static files from uploads directory

