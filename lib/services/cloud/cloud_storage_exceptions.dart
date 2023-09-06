class CloudStorageExcpetion implements Exception{
  const CloudStorageExcpetion();
}

class CouldNotCreateNoteException implements CloudStorageExcpetion{}

class CouldNotGetAllNotesException implements CloudStorageExcpetion{}

class CouldNotUpdateNoteException implements CloudStorageExcpetion{}

class CouldNotDeleteNoteException implements CloudStorageExcpetion{}
