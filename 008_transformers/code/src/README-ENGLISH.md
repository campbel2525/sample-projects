# Explanation of Configuration Values

Details of `config_dict` in `code/src/sample-transformers.py`.

## 1. "train_batch_size": 2

Batch size during training. The number of samples fed to the model per step.
Larger batches can stabilize training but consume more GPU memory. Smaller batches use less memory but may make gradient estimates noisier.

## 2. "valid_batch_size": 2

Batch size during validation. Often set equal to or larger than training batch size, but keep an eye on memory usage.

## 3. "weight_decay": 0.1

Weight decay (L2 regularization) coefficient. With AdamW, parameters are decayed on update. Common values range from 0.01 to 0.1 to reduce overfitting.

## 4. "shuffle_buffer": 1000

Buffer size used when shuffling streaming datasets.
For example: `load_dataset(..., streaming=True).shuffle(buffer_size=shuffle_buffer)`.
Larger buffers improve global shuffling but increase memory usage.

## 5. "learning_rate": 2e-4

Learning rate. Larger values can speed up learning but may destabilize training; smaller values are more stable but slower to converge.

## 6. "lr_scheduler_type": "cosine"

Type of learning rate scheduler. "cosine" uses cosine annealing to gradually reduce the LR. Alternatives include "linear" and "polynomial".

## 7. "num_warmup_steps": 750

Number of warmup steps. Gradually increases the LR for the first 750 steps before switching to the main scheduler.

## 8. "gradient_accumulation_steps": 16

Number of steps to accumulate gradients before an optimizer step. Useful when GPU memory limits the per-step batch size. Effective batch size ≈ `train_batch_size × gradient_accumulation_steps`.

## 9. "max_train_steps": 50000

Maximum number of training steps. Training ends after reaching this step count.

## 10. "max_eval_steps": -1

Maximum number of evaluation steps. `-1` means no explicit limit (implementation-dependent). Limiting this can save time on very large datasets.

## 11. "seq_length": 512

Maximum input sequence length (in tokens). Larger values allow longer context but significantly increase memory and compute.

## 12. "seed": 1

Random seed for reproducibility (affects shuffling, weight initialization, etc.).

## 13. "save_checkpoint_steps": 50000

Step interval at which to save checkpoints. Determines how often intermediate model states are saved.

