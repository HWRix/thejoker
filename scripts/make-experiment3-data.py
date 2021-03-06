"""

Create an HDF5 file containing the same RV data with random points deleted
in succession.

"""

# Standard library
import os

# Third-party
import h5py
import numpy as np

# Project
from thejoker import Paths
paths = Paths()

apogee_id = "2M03080601+7950502"

def main(seed):
    np.random.seed(seed)

    with h5py.File(paths.troup_allVisit, 'r') as f:
        bmjd = f[apogee_id]['mjd'][:]
        rv = f[apogee_id]['rv'][:]
        rv_err = f[apogee_id]['rv_err'][:]
        rv_unit = f[apogee_id]['rv'].attrs['unit']

    # HACK: downsample to 17 observations
    print("Target has {} observations".format(len(bmjd)))
    idx = np.random.choice(len(bmjd), size=len(bmjd)-17, replace=False)
    bmjd = np.delete(bmjd, idx)
    rv = np.delete(rv, idx)
    rv_err = np.delete(rv_err, idx)
    assert len(bmjd) == 17

    n_delete = 2 # HACK: MAGIC NUMBER
    with h5py.File(os.path.join(paths.root, "data", "experiment3.h5"), "w") as outf:
        outf.attrs['APOGEE_ID'] = apogee_id

        for i in range(0,14+1,n_delete): # HACK: MAGIC NUMBER
            if i > 0:
                # pick random data points to delete
                idx = np.random.choice(len(bmjd), size=n_delete, replace=False)
                bmjd = np.delete(bmjd, idx)
                rv = np.delete(rv, idx)
                rv_err = np.delete(rv_err, idx)

            g = outf.create_group(str(i))

            d = g.create_dataset('mjd', data=bmjd)
            d.attrs['format'] = 'mjd'
            d.attrs['scale'] = 'tcb'

            d = g.create_dataset('rv', data=rv)
            d.attrs['unit'] = str(rv_unit)

            d = g.create_dataset('rv_err', data=rv_err)
            d.attrs['unit'] = str(rv_unit)

            print(i, len(rv))

if __name__ == '__main__':
    from argparse import ArgumentParser

    # Define parser object
    parser = ArgumentParser(description="")

    parser.add_argument("-s", "--seed", dest="seed", default=42,
                        type=int, help="Random number seed.")

    args = parser.parse_args()

    main(args.seed)
