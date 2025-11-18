import del from 'del';

export const cleanLibrary = () => {
  return del(["./dist/*"])
}