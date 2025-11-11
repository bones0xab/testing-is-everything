# --- ÉTAPE 1: ÉTAPE DE CONSTRUCTION (BUILD STAGE) ---
# Utilise une image JDK complète avec Maven pour compiler l'application.
# Nous utilisons la version 17, qui est une version LTS (Long Term Support) stable.
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de définition de dépendance pour la mise en cache
COPY pom.xml .

# Télécharger les dépendances pour la mise en cache (si pom.xml n'a pas changé)
RUN mvn dependency:go-offline

# Copier le code source de l'application
COPY src /app/src

# Exécuter la construction du projet (produit le fichier JAR dans 'target')
# On saute les tests ici car la CI les a déjà exécutés, mais on pourrait les relancer.
RUN mvn clean install -DskipTests

# --- ÉTAPE 2: ÉTAPE DE PRODUCTION (RUNTIME STAGE) ---
# Utilise une image JRE minimale (plus légère et plus sécurisée).
# On utilise JRE 17, car l'application a été compilée en JDK 17.
FROM eclipse-temurin:17-jre-jammy

# Définir le répertoire de travail
WORKDIR /app

# Exposer le port par défaut de Spring Boot (8080)
EXPOSE 8080

# Récupérer le fichier JAR construit à partir de l'étape 'builder'
COPY --from=builder /app/target/*.jar app.jar

# Point d'entrée pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]