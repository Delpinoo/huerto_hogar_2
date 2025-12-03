import os
import base64
import uuid
from datetime import datetime, timedelta

from flask import Flask, request, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    jwt_required,
    get_jwt_identity
)
from werkzeug.security import generate_password_hash, check_password_hash
from dotenv import load_dotenv

# ================== CARGA .ENV ==================
basedir = os.path.abspath(os.path.dirname(__file__))
env_path = os.path.join(basedir, ".env")
if os.path.exists(env_path):
    load_dotenv(env_path)

# ================= CONFIGURACIÓN APP =================
app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'denuncias.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# SEGURIDAD: JWT CONFIG (OBLIGATORIO por entorno)
jwt_secret = os.getenv("JWT_SECRET_KEY")
if not jwt_secret:
    raise RuntimeError("Falta variable de entorno JWT_SECRET_KEY en .env")

app.config['JWT_SECRET_KEY'] = jwt_secret
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=8)

UPLOAD_DIR = os.path.join(basedir, "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

db = SQLAlchemy(app)
jwt = JWTManager(app)

# ================= MODELOS =================

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)

    def set_password(self, password: str):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password: str) -> bool:
        return check_password_hash(self.password_hash, password)


class Denuncia(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    correo = db.Column(db.String(120), nullable=False)
    descripcion = db.Column(db.Text, nullable=False)
    latitud = db.Column(db.Float, nullable=True)
    longitud = db.Column(db.Float, nullable=True)
    image_filename = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    def to_dict(self):
        root = request.url_root.rstrip('/')
        return {
            "id": self.id,
            "correo": self.correo,
            "descripcion": self.descripcion,
            "ubicacion": {"lat": self.latitud, "lng": self.longitud},
            "image_url": f"{root}/uploads/{self.image_filename}",
            "fecha": self.created_at.strftime("%Y-%m-%d %H:%M")
        }


with app.app_context():
    db.create_all()

# ========== MANEJO DE ERRORES JWT (REQUISITO Pauta) ==========

@jwt.unauthorized_loader
def unauthorized_callback(err_str):
    # Cuando falta el header Authorization
    return jsonify({"msg": "Token faltante o no enviado", "detail": err_str}), 401


@jwt.invalid_token_loader
def invalid_token_callback(err_str):
    # Token mal formado o manipulado
    return jsonify({"msg": "Token inválido", "detail": err_str}), 422


@jwt.expired_token_loader
def expired_token_callback(jwt_header, jwt_payload):
    # Token expirado
    return jsonify({"msg": "Token expirado"}), 401


# ================= RUTAS DE AUTENTICACIÓN =================

@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json() or {}
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"msg": "Faltan email o password"}), 400

    # Opcional: solo correos duocuc
    # if not email.lower().endswith("@duocuc.cl"):
    #     return jsonify({"msg": "Solo se permiten correos @duocuc.cl"}), 400

    if User.query.filter_by(email=email).first():
        return jsonify({"msg": "El usuario ya existe"}), 400

    new_user = User(email=email)
    new_user.set_password(password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"msg": "Usuario creado exitosamente"}), 201


@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json() or {}
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"msg": "Faltan credenciales"}), 400

    user = User.query.filter_by(email=email).first()

    if not user or not user.check_password(password):
        return jsonify({"msg": "Credenciales inválidas"}), 401

    # Crear Token JWT
    access_token = create_access_token(identity=email)
    return jsonify(access_token=access_token), 200


# ================= RUTAS DE DENUNCIAS =================

@app.route("/api/denuncias", methods=["GET"])
@jwt_required()
def list_denuncias():
    try:
        items = Denuncia.query.order_by(Denuncia.id.desc()).all()
        return jsonify([i.to_dict() for i in items]), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/denuncias", methods=["POST"])
@jwt_required()
def create_denuncia():
    current_user = get_jwt_identity()
    data = request.get_json(silent=True) or {}

    correo = current_user
    descripcion = data.get("descripcion")
    img_b64 = data.get("foto")
    ubicacion = data.get("ubicacion", {})

    if not descripcion or not img_b64:
        return jsonify({"error": "Faltan datos"}), 400

    # Procesar imagen
    try:
        if "," in img_b64:
            img_b64 = img_b64.split(",")[1]
        raw_image = base64.b64decode(img_b64, validate=True)
        filename = f"{uuid.uuid4().hex}.jpg"
        file_path = os.path.join(UPLOAD_DIR, filename)
        with open(file_path, "wb") as f:
            f.write(raw_image)
    except Exception as e:
        return jsonify({"error": f"Error imagen: {str(e)}"}), 400

    # Guardar en BD
    try:
        nueva = Denuncia(
            correo=correo,
            descripcion=descripcion,
            latitud=ubicacion.get("lat"),
            longitud=ubicacion.get("lng"),
            image_filename=filename
        )
        db.session.add(nueva)
        db.session.commit()
        return jsonify(nueva.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": f"Error BD: {str(e)}"}), 500


@app.route("/api/denuncias/<int:id>", methods=["GET"])
@jwt_required()
def get_denuncia(id):
    denuncia = Denuncia.query.get(id)
    if not denuncia:
        return jsonify({"error": "No encontrado"}), 404
    return jsonify(denuncia.to_dict()), 200


@app.route("/api/denuncias/<int:id>", methods=["DELETE"])
@jwt_required()
def delete_denuncia(id):
    denuncia = Denuncia.query.get(id)
    if not denuncia:
        return jsonify({"error": "No encontrado"}), 404

    try:
        # borrar imagen física
        if denuncia.image_filename:
            path = os.path.join(UPLOAD_DIR, denuncia.image_filename)
            if os.path.exists(path):
                os.remove(path)
    except Exception as e:
        print(f"Advertencia al borrar imagen: {e}")

    try:
        db.session.delete(denuncia)
        db.session.commit()
        return jsonify({"msg": "Denuncia eliminada"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500


@app.route('/uploads/<filename>')
def serve_image(filename):
    return send_from_directory(UPLOAD_DIR, filename)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
