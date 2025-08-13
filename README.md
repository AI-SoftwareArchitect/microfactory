# 🏭 Microservice Factory

**Minimal kod ile maksimum microservice üretimi!**

Microservice Factory, YAML konfigürasyonundan otomatik olarak production-ready microservice'ler üreten gelişmiş bir CLI aracıdır. ASP.NET Core, Spring Boot ve Node.js ile CQRS, Event-Driven Architecture destekli projeler oluşturur.

## ✨ Özellikler

- 🚀 **3 Framework Desteği**: .NET 9, Java 21 (Spring Boot), Node.js
- 🏗️ **Mimari Desenleri**: CQRS, Event-Driven Architecture, N-Tier
- 🔐 **JWT Kimlik Doğrulama**: Otomatik API Gateway ile entegre
- 🐘 **Veritabanı Desteği**: PostgreSQL, MongoDB
- 📨 **Event Messaging**: Apache Kafka entegrasyonu
- 🐳 **Docker Support**: Development için hazır Docker Compose
- 🎯 **Template Engine**: Otomatik Entity, DTO, Repository, Service üretimi
- 🔒 **Security Best Practices**: Hashed password, JWT, rate limiting

## 📋 Gereksinimler

- Python 3.8+
- Docker & Docker Compose (opsiyonel, geliştirme için önerilir)
- .NET 9 SDK (eğer .NET servisleri kullanacaksanız)
- Java 21 JDK (eğer Java servisleri kullanacaksanız)
- Node.js 18+ (eğer Node.js servisleri kullanacaksanız)

## 🚀 Hızlı Kurulum

### 1. Projeyi İndirin
```bash
git clone <repository-url>
cd microservice-factory
```

### 2. Kurulum Scriptini Çalıştırın
```bash
chmod +x setup.sh
./setup.sh
```

### 3. Doğrulama
```bash
microfactory --help
```

## 💡 Kullanım

### 1. Proje Dizini Oluşturun
```bash
mkdir my-ecommerce-project
cd my-ecommerce-project
```

### 2. architect.yaml Oluşturun
```yaml
project_name: "my-ecommerce"

services:
  user:
    language: dotnet
    database: postgresql
    architecture: cqrs
    entities:
      User:
        username: string
        email: string
        password: hashed-string
        firstName: string
        lastName: string
        isActive: bool
    events:
      - UserRegistered
      - UserUpdated

  product:
    language: java
    database: postgresql
    architecture: cqrs
    entities:
      Product:
        name: string
        price: float
        stock: int
        category: string
    events:
      - ProductCreated
      - StockUpdated

  order:
    language: nodejs
    database: mongodb
    architecture: event-driven
    entities:
      Order:
        userId: string
        status: string
        totalAmount: float
        items: string
    events:
      - OrderCreated
      - OrderCompleted
```

### 3. Microservice'leri Oluşturun
```bash
microfactory
```

### 4. Geliştirme Ortamını Başlatın
```bash
docker-compose up -d
```

## 📁 Oluşturulan Proje Yapısı

```
my-ecommerce-project/
├── api-gateway/              # Node.js API Gateway (JWT Auth)
├── services/
│   ├── user-service/         # .NET Core Service
│   │   ├── User.Api/
│   │   ├── User.Application/ # CQRS Commands/Queries
│   │   ├── User.Domain/      # Entities & Events  
│   │   └── User.Infrastructure/ # Repository & DbContext
│   ├── product-service/      # Spring Boot Service
│   │   ├── src/main/java/
│   │   └── pom.xml
│   └── order-service/        # Node.js Service
│       ├── src/models/
│       ├── src/controllers/
│       └── package.json
├── docker-compose.yml        # Development Environment
├── architect.yaml           # Your Configuration
└── README.md               # Generated Documentation
```

## 🔧 Konfigürasyon Detayları

### Desteklenen Diller
- `dotnet`: ASP.NET Core 9.0 + Entity Framework
- `java`: Spring Boot 3.2 + JPA + Maven
- `nodejs`: Express.js + Mongoose/Sequelize

### Desteklenen Veritabanları
- `postgresql`: PostgreSQL (önerilen)
- `mongodb`: MongoDB (Node.js servisleri için ideal)

### Mimari Türleri
- `cqrs`: Command Query Responsibility Segregation
- `event-driven`: Event-Driven Architecture
- `n-tier`: Traditional N-Tier Architecture

### Entity Field Türleri
- `string`: Metin alanı
- `int`: Tam sayı
- `float`: Ondalık sayı
- `bool`: Boolean değer
- `datetime`: Tarih/Saat
- `hashed-string`: Otomatik hash'lenen password alanı

## 🌐 API Gateway

Otomatik oluşturulan API Gateway özellikleri:

- **Port**: 8080
- **Authentication**: JWT tabanlı
- **Rate Limiting**: IP başına 100 req/15dk
- **CORS**: Konfigürasyonlu
- **Proxy**: Servislere otomatik yönlendirme

### Kimlik Doğrulama
```bash
# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "password"}'

# Token ile API çağrısı
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8080/api/user/users
```

## 🐳 Docker Ortamı

### Servisler
- **API Gateway**: 8080
- **PostgreSQL**: 5432
- **MongoDB**: 27017  
- **Kafka**: 9092
- **Kafka UI**: 8081
- **Zookeeper**: 2181

### Komutlar
```bash
# Tüm servisleri başlat
docker-compose up -d

# Logları görüntüle
docker-compose logs -f

# Servisleri durdur
docker-compose down

# Veritabanı sıfırlama
docker-compose down -v
docker-compose up -d
```

## 🎯 Gelişmiş Özellikler

### Event-Driven Messaging
- Kafka entegrasyonu otomatik kurulur
- Her servis kendi event'larını publish eder
- Cross-service communication için hazır

### CQRS Pattern
- Command ve Query ayrımı
- MediatR (.NET) entegrasyonu
- Otomatik DTO mapping

### Security Best Practices
- Password hashing (bcrypt)
- JWT token validation
- Rate limiting
- CORS protection
- Helmet.js security headers

## 🚀 Production Hazırlığı

### Environment Variables
```bash
# .env dosyası oluşturun
JWT_SECRET=your-production-jwt-secret
DATABASE_URL=your-production-database-url
KAFKA_BROKERS=your-kafka-brokers
```

### Deployment
1. Docker images build edin
2. Container registry'ye push edin  
3. Kubernetes/Docker Swarm ile deploy edin
4. Load balancer ekleyin
5. Monitoring & logging kurulumu

## 📝 Örnekler

### E-commerce Platform
```bash
cp example-project/architect.yaml .
# Kullanıcı, ürün, sipariş ve bildirim servisleri
microfactory
```

### Blog Platform
```yaml
services:
  user:
    language: dotnet
    entities:
      User:
        username: string
        email: string
        password: hashed-string
  
  blog:
    language: nodejs
    database: mongodb
    entities:
      Post:
        title: string
        content: string
        authorId: string
        publishedAt: datetime
```

**⭐ Beğendiyseniz yıldız vermeyi unutmayın!**

Made with ❤️ for developers who love clean architecture and minimal code.
