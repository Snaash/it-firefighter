statut_port = "down"

if statut_port == "up":
    print("Le port est actif. Tout va bien !")
elif statut_port == "down":
    print("Alerte ! Le port est éteint. Il faut agir !")
else:
    print("Statut inconnu. Vérifiez les branchements.")
