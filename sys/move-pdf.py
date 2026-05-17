import shutil
from pathlib import Path

def organiser_pdfs():
    # Définition des dossiers source et destination
    source_dir = Path('/home/malik/Downloads')
    dest_dir = Path('/home/malik/Documents')

    # Sécurité : s'assurer que le dossier de destination existe
    dest_dir.mkdir(parents=True, exist_ok=True)

    # Parcours des fichiers dans le dossier de téléchargement
    # .glob('*.pdf') permet d'isoler uniquement les fichiers PDF
    for fichier_pdf in source_dir.glob('*.pdf'):
        try:
            # Construction du chemin de destination final
            chemin_destination = dest_dir / fichier_pdf.name
            
            # Déplacement du fichier
            shutil.move(str(fichier_pdf), str(chemin_destination))
            print(f"Déplacé : {fichier_pdf.name}")
            
        except Exception as e:
            print(f"Erreur lors du déplacement de {fichier_pdf.name} : {e}")

if __name__ == "__main__":
    organiser_pdfs()
