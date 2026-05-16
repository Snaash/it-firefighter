charge = 90

if charge > 90:
    print("Saturation !")
elif charge >= 50:    # Si on est ici, c'est que charge est forcément <= 90
    print("Vigilance")
else:                 # Dans tous les autres cas (forcément < 50)
    print("Optimale")
