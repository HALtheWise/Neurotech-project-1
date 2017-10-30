import numpy as np
import sys
import nibabel as nib

def mni2tal(pt):
    xf = [
            0.88, 0.0 ,  0.0 ,  -0.8,
            0.0 , 0.97,  0.0 ,  -3.32,
            0.0 , 0.05,  0.88,  -0.44,
            0.0 , 0.0 ,  0.0 ,   1.0
            ]
    xf = np.reshape(xf, (4,4))
    res = np.tensordot(pt, xf, (-1,1))
    return res[..., :-1]
    #return np.tensordot(xf, pt, (1,-1))

def convert(img, tal, ieee):
    # img = (...)
    # tal = (...,3)
    # ieee = shape (278,3)
    # ieee : contains talairach coordinate mappings
    # mapping from 278 to 7 regions

    tal = np.reshape(tal, [-1,3])
    img = np.reshape(img, [-1])

    ieee = np.expand_dims(ieee, 1)
    tal = [np.expand_dims(tal[img==i], 0) for i in range(1,8)]

    # tal = list of points belonging to Yeo region i

    # compute distance to each points
    ds = [np.linalg.norm(ieee-t,axis=-1) for t in tal]
    # ds = (7,278,N_RGN)

    # compute closest point between yeo and ieee
    ds = [np.min(d, axis=-1) for d in ds]

    i2y = np.argmin(ds, axis=0)
    return i2y

img = nib.load('Yeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii')

# voxel space
vxl = np.indices(img.shape[:-1])
vxl = np.concatenate([vxl, np.ones([1] + list(vxl.shape[1:]))], axis=0)

# mni space
mni = np.tensordot(vxl, img.affine, (0,1))

# tal space
tal = mni2tal(mni)

d = np.max(tal) - np.min(tal)
ieee = np.random.uniform(low=np.min(tal), high=np.max(tal), size=(278,3))
print convert(img.get_data(), tal, ieee)

