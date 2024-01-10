import tensorflow as tf
from tensorflow.python.keras import backend as K
import numpy as np

print("Tensorflow version: ", tf.__version__)
print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))

x = np.random.random(size=(16384, 3))
y = 3 * x[:, 0] ** 2 + 2 * x[:, 1] - x[:, 2]

mod = tf.keras.models.Sequential()
mod.add(tf.keras.layers.Dense(10, input_shape=(3,)))
mod.add(tf.keras.layers.Activation("relu"))
mod.add(tf.keras.layers.Dense(1))
mod.compile(loss="mse", optimizer="adam")
mod.fit(x, y, epochs=10, batch_size=128)
