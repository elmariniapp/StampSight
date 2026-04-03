/// Mode d’ouverture de l’écran caméra.
enum CaptureLaunchMode {
  /// Première photo : remplace la route par la confirmation.
  newProof,

  /// Photo complémentaire pour un brouillon : [Navigator.pop] avec le chemin fichier.
  addPhotoToDraft,
}
