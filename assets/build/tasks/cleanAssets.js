import del from 'del';

export const cleanAssets = () => {
  return del(["./dist/*"])
}