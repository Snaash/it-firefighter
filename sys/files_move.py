import shutil
from pathlib import Path

# 1. On définit le dossier à nettoyer (par défaut : ton dossier Téléchargements)
# Path.home() cible automatiquement le dossier de ton utilisateur (ex: C:\Users\Nom)
dossier_source = Path.home() / "Downloads"

# 2. On associe chaque extension à son dossier de destination standard
ORGANISATION = {
    # --- DOCUMENTS ---
    ".pdf": Path.home() / "Documents",
    ".odt": Path.home() / "Documents",
    ".docx": Path.home() / "Documents",
    ".doc": Path.home() / "Documents",
    ".txt": Path.home() / "Documents",
    ".xlsx": Path.home() / "Documents",
    ".pptx": Path.home() / "Documents",
    # --- VIDÉOS ---
    ".mp4": Path.home() / "Videos",
    ".mkv": Path.home() / "Videos",
    ".avi": Path.home() / "Videos",
    ".mov": Path.home() / "Videos",
    # --- IMAGES ---
    ".jpg": Path.home() / "Pictures",
    ".jpeg": Path.home() / "Pictures",
    ".png": Path.home() / "Pictures",
    ".gif": Path.home() / "Pictures",
}


def organiser_dossier():
    # Sécurité : On vérifie que le dossier source existe bien avant de bosser
    if not dossier_source.exists():
        print(f"Le dossier cible {dossier_source} n'existe pas.")
        return

    print(f"Analyse et tri du dossier : {dossier_source}...")
    fichiers_deplaces = 0

    # On passe au crible chaque élément du dossier source
    for element in dossier_source.iterdir():

        # On ne traite QUE les fichiers (on ignore les dossiers déjà présents)
        if element.is_file():
            # .lower() gère les cas où l'extension est en majuscules (ex: .PDF)
            extension = element.suffix.lower()

            # Si l'extension fait partie de notre dictionnaire de tri
            if extension in ORGANISATION:
                dossier_cible = ORGANISATION[extension]

                # Automatisation : On crée le dossier de destination s'il n'existe pas
                dossier_cible.mkdir(parents=True, exist_ok=True)

                # On construit le chemin de destination final (Dossier + Nom du fichier)
                chemin_final = dossier_cible / element.name

                # Gestion du déplacement avec capture d'erreur pour éviter le crash
                try:
                    shutil.move(str(element), str(chemin_final))
                    print(
                        f" [OK] {element.name} -> Dossier {dossier_cible.name}"
                    )
                    fichiers_deplaces += 1
                except Exception as e:
                    print(f" [ERREUR] Impossible de déplacer {element.name}: {e}")

    print(f"\nTraitement terminé. {fichiers_deplaces} fichier(s) rangé(s) !")


if __name__ == "__main__":
    organiser_dossier()
